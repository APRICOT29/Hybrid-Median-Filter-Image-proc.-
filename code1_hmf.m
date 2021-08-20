function A = hmf(A,n)
error(nargchk(1,2,nargin));
if nargin==1, n = 5; end
if ~isscalar(n) || n<0, n = 5; end
n = round(n);
if rem(n+1,2)~=0, n = n+1; end
isRGB = ndims(A)==3 && (isfloat(A) || isa(A,'uint8') || isa(A,'uint16'));
if isRGB
if isfloat(A)
mm = size(A,1);
nn = size(A,2);
chunk = A(1:min(mm,10),1:min(nn,10),:); 
isRGB = (min(chunk(:))>=0 && max(chunk(:))<=1);
% If the chunk is an RGB image, test the whole image
if isRGB
isRGB = (min(A(:))>=0 && max(A(:))<=1);
end
end
end
assert(isRGB | ndims(A)==2,...
'The input must be a 2-D array or an RGB image.')
classA = class(A);
if isRGB
A = rgb2hsv(A);
for k = 1:3, A(:,:,k) = hmf(A(:,:,k),n); end
A = hsv2rgb(A);
switch classA
case 'uint8'
A = uint8(A*255);
case 'uint16'
Image Processing 17 CSE-4019
A = uint16(A*65535);
case 'single'
A = single(A);
end
return
end
Plus = false(n,n);
Plus((n+1)/2,:) = true;
Plus(:,(n+1)/2) = true;
Plus = Plus(:);
Cross = false(n,n);
Cross((1:n)+n*(0:n-1)) = true;
Cross((1:n)+n*((n-1):-1:0)) = true;
Cross = Cross(:);
existNaNmedian = exist('nanmedian','file');
A = padarray(A,[(n-1)/2 (n-1)/2],'replicate');
M1 = colfilt(A,[n n],'sliding',@CrossMedian);
M2 = colfilt(A,[n n],'sliding',@PlusMedian);
if existNaNmedian
 A = nanmedian(cat(3,A,M1,M2),3);
else
 A = median(cat(3,A,M1,M2),3);
end
A = A((n+1)/2:end-(n-1)/2,(n+1)/2:end-(n-1)/2);
function CM = CrossMedian(X)
 ncol = size(X,2);
 I = repmat(Cross,[1 ncol]);
 X = reshape(X(I),[2*n-1 ncol]);
 if existNaNmedian
 CM = nanmedian(X);
 else
 CM = median(X);
 end
end
function PM = PlusMedian(X)
 ncol = size(X,2);
 I = repmat(Plus,[1 ncol]);
 X = reshape(X(I),[2*n-1 ncol]);
 if existNaNmedian
 PM = nanmedian(X);
 else
 PM = median(X);
 end
end
end
