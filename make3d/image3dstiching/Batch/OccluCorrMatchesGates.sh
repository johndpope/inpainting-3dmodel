# *  This code was used in the following articles:
# *  [1] Learning 3-D Scene Structure from a Single Still Image, 
# *      Ashutosh Saxena, Min Sun, Andrew Y. Ng, 
# *      In ICCV workshop on 3D Representation for Recognition (3dRR-07), 2007.
# *      (best paper)
# *  [2] 3-D Reconstruction from Sparse Views using Monocular Vision, 
# *      Ashutosh Saxena, Min Sun, Andrew Y. Ng, 
# *      In ICCV workshop on Virtual Representations and Modeling 
# *      of Large-scale environments (VRML), 2007. 
# *  [3] 3-D Depth Reconstruction from a Single Still Image, 
# *      Ashutosh Saxena, Sung H. Chung, Andrew Y. Ng. 
# *      International Journal of Computer Vision (IJCV), Aug 2007. 
# *  [6] Learning Depth from Single Monocular Images, 
# *      Ashutosh Saxena, Sung H. Chung, Andrew Y. Ng. 
# *      In Neural Information Processing Systems (NIPS) 18, 2005.
# *
# *  These articles are available at:
# *  http://make3d.stanford.edu/publications
# * 
# *  We request that you cite the papers [1], [3] and [6] in any of
# *  your reports that uses this code. 
# *  Further, if you use the code in image3dstiching/ (multiple image version),
# *  then please cite [2].
# *  
# *  If you use the code in third_party/, then PLEASE CITE and follow the
# *  LICENSE OF THE CORRESPONDING THIRD PARTY CODE.
# *
# *  Finally, this code is for non-commercial use only.  For further 
# *  information and to obtain a copy of the license, see 
# *
# *  http://make3d.stanford.edu/publications/code
# *
# *  Also, the software distributed under the License is distributed on an 
# * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either 
# *  express or implied.   See the License for the specific language governing 
# *  permissions and limitations under the License.
# *
# */

#!/bin/bash

# Change to the submission directory
cd $PBS_O_WORKDIR

# Run the m-file
matlab -nojvm -nodisplay > OccluCorrMatches.out << EOF

% Run your MATLAB commands inlin
cd ..
image3dstichingSetPath
Fdir ='/afs/cs/group/reconstruction3d/scratch/TestMultipleImage/COM4_070525_001900_gates';
WrlName = 'Multi_GateMetaGateHilbertFixGround'
%Fdir ='/afs/cs/group/reconstruction3d/scratch/TestMultipleImage/COM5_070428_main_quad_123456789';
%WrlName = 'Multi_Multi_QuidMetaTest3ImgHighCop200Tri2_FixG';
PairList = [];
%PairList = [ PairList; {'IMG_0663','IMG_0668'}];
PairList = [ PairList; {'IMG_0669','IMG_0668'}];
PairList = [ PairList; {'IMG_0669','IMG_0675'}];
PairList = [ PairList; {'IMG_0677','IMG_0676'}];
%PairList = [ PairList; {'IMG_0606','IMG_0610'}];

FlagSetup;
Flag.FlagPreloadOccluDetect = 0;
Flag.FlagOccluDetect = 1;
Stiching3dParameterSetup;
tic;
OcclusionRefineMent(defaultPara, WrlName, PairList,'TestOccluCorrMatches','Corrmatches');
toc;

cd Batch/;

% Exit MATLAB
exit
EOF

# Display the output
cat OccluCorrMatches.out
