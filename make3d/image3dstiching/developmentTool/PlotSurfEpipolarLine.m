% *  This code was used in the following articles:
% *  [1] Learning 3-D Scene Structure from a Single Still Image, 
% *      Ashutosh Saxena, Min Sun, Andrew Y. Ng, 
% *      In ICCV workshop on 3D Representation for Recognition (3dRR-07), 2007.
% *      (best paper)
% *  [2] 3-D Reconstruction from Sparse Views using Monocular Vision, 
% *      Ashutosh Saxena, Min Sun, Andrew Y. Ng, 
% *      In ICCV workshop on Virtual Representations and Modeling 
% *      of Large-scale environments (VRML), 2007. 
% *  [3] 3-D Depth Reconstruction from a Single Still Image, 
% *      Ashutosh Saxena, Sung H. Chung, Andrew Y. Ng. 
% *      International Journal of Computer Vision (IJCV), Aug 2007. 
% *  [6] Learning Depth from Single Monocular Images, 
% *      Ashutosh Saxena, Sung H. Chung, Andrew Y. Ng. 
% *      In Neural Information Processing Systems (NIPS) 18, 2005.
% *
% *  These articles are available at:
% *  http://make3d.stanford.edu/publications
% * 
% *  We request that you cite the papers [1], [3] and [6] in any of
% *  your reports that uses this code. 
% *  Further, if you use the code in image3dstiching/ (multiple image version),
% *  then please cite [2].
% *  
% *  If you use the code in third_party/, then PLEASE CITE and follow the
% *  LICENSE OF THE CORRESPONDING THIRD PARTY CODE.
% *
% *  Finally, this code is for non-commercial use only.  For further 
% *  information and to obtain a copy of the license, see 
% *
% *  http://make3d.stanford.edu/publications/code
% *
% *  Also, the software distributed under the License is distributed on an 
% * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either 
% *  express or implied.   See the License for the specific language governing 
% *  permissions and limitations under the License.
% *
% */
function []=PlotSurfEpipolarLine(defaultPara, Fdir, Img1, Img2)

% Function plot the epipolar line and all the surfFeatures

load([ Fdir '/data/' Img1 '_' Img2 '_PoseMatch.mat']);
I1=imreadbw([Fdir '/pgm/' Img1 '.pgm']); % function from sift
I2=imreadbw([Fdir '/pgm/' Img2 '.pgm']); % function from sift
[f1] = readSurf(Img1, Fdir, 'Dense'); % original features
[f2] = readSurf(Img2, Fdir, 'Dense'); % original features
D1 = zeros(1,length(f1));
D2 = zeros(1,length(f2));
CalMatchSearchRegin(defaultPara, [Pair.R; Pair.R'], [Pair.T; -Pair.R'*Pair.T], I1, I2, f1, f2, D1, D2, 1, 1);

return;
