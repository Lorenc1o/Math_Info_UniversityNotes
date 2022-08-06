## Copyright (C) 2019 Antonio Pallares
## 
## This program is free software: you can redistribute it and/or modify it
## under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
## 
## This program is distributed in the hope that it will be useful, but
## WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
## 
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see
## <https://www.gnu.org/licenses/>.

## -*- texinfo -*- 
## @deftypefn {} {@var{retval} =} difAproximada (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: Antonio Pallares <antonio@pallares>
## Created: 2019-05-08

function Ja = difAproximada (F, X)
 n=length(X);
 Ja=zeros(n,n);
 global paso;
 for j=1:n
   Z=X;
   Z(j)=X(j)+paso;
   Y=feval(F,Z);
   Z(j)=X(j)-paso;
   Yj=feval(F,Z);
   for i=1:n
     Ja(i,j)=(Y(i)-Yj(i))/(2*paso);
   end
 end

endfunction
