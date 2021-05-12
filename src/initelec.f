c
c   Dint – version 2.0  is licensed under the Apache License, Version 2.0 (the "License");
c   you may not use Dint – version 2.0 except in compliance with the License.
c   You may obtain a copy of the License at
c       http://www.apache.org/licenses/LICENSE-2.0
c   The license is also given in the LICENSE file.
c   Unless required by applicable law or agreed to in writing, software
c   distributed under the License is distributed on an "AS IS" BASIS,
c   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
c   See the License for the specific language governing permissions and limitations under the License.
c
c -------------------------------------------------------------------------------------------
c  Dint : Direct Nonadiabatic Trajectories A code for non-Born–Oppenheimer molecular dynamics 
c  
c  version 2.0                                    
c
c  A. W. Jasper                  
c  Argonne National Laboratory     
c
c  Rui Ming Zhang                 
c  Tsinghua University
c               
c  and                  
c    
c  D. G. Truhlar                 
c  University of Minnesota
c
c  copyright  2020
c  Donald G. Truhlar and Regents of the University of Minnesota 
c----------------------------------------------------------------------------------------------


      subroutine initelec

C PREPARE INITIAL ELECTRONIC VARIABLES
c Real and imaginary parts all set to 0 except for real part
c of the initially occupied state

      implicit none
      include 'param.f'
      include 'c_sys.f'
      include 'c_traj.f'
      integer i

      do i=1,nsurft
      crei(i) = 0.d0
      cimi(i) = 0.d0
      enddo
      crei(nsurf) = 1.d0

      do i=1,2*nsurft
      cre(i) = 0.d0
      cim(i) = 0.d0
      enddo
      cre(nsurf) = 1.d0
c     used for CSDM
      cre(nsurf+nsurft) = 1.d0
       
      return

      end
