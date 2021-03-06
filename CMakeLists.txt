####################################################
#                                                  #
# Compiles DiNT (Direct Nonadiabatic Trajectories) #
#   for Linux                                      #
#                                                  #
####################################################
project(DiNT Fortran)
cmake_minimum_required(VERSION 3.12)

# Define potential to compile
set(POT
#"tbplusexp6-2"
#"tbplusexp6all"
"ch4hALL"
#"ch4oALL"

##TINKER PES
#NOTE: obj_tinker contains link to mm3 PES
#NOTE: obj_tinker2 contains link to amoeba09 PES
#NOTE: obj_tinker3 contains link to oplsaa PES
#"alkT"
)

# Define locations of directories and libraries
#set(SPRNG_DIR "/home/ajasper/KTP/dint/sprng")
set(SPRNG_DIR "/home/moberg/codes/sprng")
set(LIB_DIR "/home/moberg/lib")
#set(LIB_DIR "/usr/lib64")
#set(TINKER_LIB "/home/ajasper/KTP/dint/tinker/tinker")
set(TINKER_OBJS "/home/moberg/codes/pacchem/DiNT/src/obj_tinker")
set(TINKER_OBJS2 "/home/moberg/codes/pacchem/DiNT/src/obj_tinker2")
set(TINKER_OBJS3 "/home/moberg/codes/pacchem/DiNT/src/obj_tinker3")

# Include Tinker?
option(USE_TINKER "Use Tinker software" 
#ON
OFF
)

# MKL Intel Libraries?
option(USE_MKL_LIBS "Use MKL Libraries"
ON
#OFF
)

# Use MPI?
option(USE_MPI "Use MPI"
ON
#OFF
)

#-------------------------------------------------------#

set(BLAS_DIR "${LIB_DIR}")
set(LAPACK_DIR "${LIB_DIR}")

if(NOT USE_MKL_LIBS)
    find_package(BLAS REQUIRED)
    find_package(LAPACK REQUIRED)

    if(LAPACK_FOUND AND BLAS_FOUND)
        set(lapackblas_libraries ${BLAS_LIBRARIES} ${LAPACK_LIBRARIES})
    endif()

    message(STATUS "Found BLAS: ${BLAS_LIBRARIES}")
    message(STATUS "Found LAPACK: ${LAPACK_LIBRARIES}")
endif()

add_subdirectory("src")
list(APPEND EXTRA_INCLUDES "${CMAKE_SOURCE_DIR}/src")
list(APPEND EXTRA_INCLUDES "${SPRNG_DIR}/SRC")
list(APPEND EXTRA_INCLUDES "${CMAKE_SOURCE_DIR}/..")
list(APPEND EXTRA_INCLUDES "${LIB_DIR}")
list(APPEND EXTRA_INCLUDES "/usr/lib64")

if(USE_TINKER)
  list(APPEND EXTRA_INCLUDES "${TINKER_DIR}/source")
endif(USE_TINKER)

if(USE_MPI)
  find_package(MPI REQUIRED)
  list(APPEND EXTRA_INCLUDES "${MPI_INCLUDE_PATH}")
  if(MPI_FOUND)
    list(APPEND EXTRA_FFLAGS "-DMPI")
    include_directories(${MPI_Fortran_INCLUDE_DIRS})
  endif(MPI_FOUND)
endif(USE_MPI)

# Link SPRNG libraries
#link_directories("${SPRNG_DIR}/lib")
list(APPEND EXTRA_LIBS "${SPRNG_DIR}/lib/libcmrg.a" "${SPRNG_DIR}/lib/liblcg64.a" "${SPRNG_DIR}/lib/liblcg.a" "${SPRNG_DIR}/lib/liblfg.a" "${SPRNG_DIR}/lib/libsprngtest.a")

add_executable(dint-${POT}.x $<TARGET_OBJECTS:objs> ${CMAKE_SOURCE_DIR}/src/)

if(USE_MKL_LIBS)
    set(EXTRA_FFLAGS "-O3 -g -mkl -lmlfg -L${SPRNG_DIR}/lib -L/usr/lib64 -L${LIB_DIR}")
else()
    set(EXTRA_FFLAGS "-O3 -g -lmlfg -L${SPRNG_DIR}/lib -L/usr/lib64 -L${LIB_DIR}")
endif(USE_MKL_LIBS)

set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} ${EXTRA_FFLAGS}")
#target_link_options(dint-${POT}.x PRIVATE
#    "-llapack -lablas -lmlfg"
#)
if(USE_TINKER)
    list(APPEND TINKER_FLAGS "-ffast-math -fopenmp -static-libgcc")
    set_target_properties(dint-${POT}.x PROPERTIES
                        COMPILE_FLAGS "${TINKER_FLAGS}")
    list(APPEND EXTRA_LIBS "${TINKER_LIB}/libtinker.a" "${TINKER_LIB}/libfftw3_threads.a" "${TINKER_LIB}/libfftw3.a")
    target_link_libraries(dint-${POT}.x PUBLIC
       ${TINKER_LIBS})
endif(USE_TINKER)

if(USE_MPI)
  list(APPEND MPI_LIBS "${MPI_LIBRARIES}")
  target_link_libraries(dint-${POT}.x PUBLIC
       ${MPI_LIBS})
endif(USE_MPI)

target_link_libraries(dint-${POT}.x PUBLIC
    ${BLAS_LIBRARIES} ${LAPACK_LIBRARIES} ${EXTRA_LIBS})

target_include_directories(dint-${POT}.x PUBLIC ${EXTRA_INCLUDES})

if(MPI_COMPILE_FLAGS)
  set_target_properties(dint-${POT}.x PROPERTIES
                        COMPILE_FLAGS "${MPI_COMPILE_FLAGS}")
endif()

if(MPI_LINK_FLAGS)
  set_target_properties(dint-${POT}.x PROPERTIES
                        LINK_FLAGS "${MPI_LINK_FLAGS}")
endif()

install(TARGETS dint-${POT}.x DESTINATION exe)

#$(LD) $(LDFLAGS) $(OBJ) $(LIBS) -o $(TARG)
#gfortran -O3 -g -L../../sprng/lib -L/usr/lib64 -L/home/ajasper/lib OBJ -llapack -lblas -lmlfg -o dint-${POT}.x
