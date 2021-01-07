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
c  Argonne National Laboratories     
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
c  Donald G. Truhalar and Regents of the University of Minnesota 
c----------------------------------------------------------------------------------------------


c COMMON BLOCK FOR FREQUENTLY USED VARIABLES THAT RELATE TO SPRNG

c NOTE: This bit of code has memory problems. 
c       When trajlist is used, SPRNG will crash when called.
c       It seems to be fixed once I reordered the elements in the block.
c       If problems occur, maybe don't call sprng using a variable in 
c       the common block; use a temporary variable instead?

c ranseed = randum number seed
c rng_stream = randum number stream
c trajlist = list of restart trajectory indices
c maxtraj = maximum trajectory index for this run

      integer ranseed,rng_stream,maxtraj,trajlist(mntraj)

      common /c_ran/ranseed,maxtraj,trajlist
      common /c_ran0/rng_stream