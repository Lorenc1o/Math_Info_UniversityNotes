function c = dctmtx(n)
%DCTMTX Compute discrete cosine transform matrix.
%   D = DCTMTX(N) returns the N-by-N DCT transform matrix.  D*A
%   is the DCT of the columns of A and D'*A is the inverse DCT of
%   the columns of A (when A is N-by-N).
%
%   If A is square, the two-dimensional DCT of A can be computed
%   as D*A*D'. This computation is sometimes faster than using
%   DCT2, especially if you are computing large number of small
%   DCT's, because D needs to be determined only once.
%
%   Class Support
%   -------------
%   N is a scalar of class double. D is returned as a matrix of
%   class double.
%   
%   See also DCT2.

%   Copyright 1993-2001 The MathWorks, Inc.  
%   $Revision: 5.15 $  $Date: 2001/01/18 15:28:53 $

%   References:
%   Jain, Fundamentals of Digital Image Processing, p. 150.

[cc,rr] = meshgrid(0:n-1);

c = sqrt(2 / n) * cos(pi * (2*cc + 1) .* rr / (2 * n));
c(1,:) = c(1,:) / sqrt(2);
