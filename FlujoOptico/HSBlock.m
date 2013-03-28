function [ u, v, diffunorm, diffvnorm ] = HSBlock(subFrame1, subFrame2, subIx, subIy, subIt, rows, cols)
    
for i=1:rows
   for j=1:cols
        
       Ixij = subIx(i,j);
       Iyij = subIy(i,j);
       Itij = subIt(i,j);
       
       u(i,j) = uprev - Ixij * ((Ixij * uprev + Iyij * vprev + Itij)/(lamda^2 + Ixij^2 + Iyij^2));
       v(i,j) = vprev - Iyij * ((Ixij * uprev + Iyij * vprev + Itij)/(lamda^2 + Ixij^2 + Iyij^2));
   end;
end;

     
    for i=1:m
       for j=1:n
           Ixij = Ix(i,j);
           Iyij = Iy(i,j);
           Itij = It(i,j);
           uprevij = uprev(i,j);
           vprevij = vprev(i,j);

           u(i,j) = uprevij - Ixij * ((Ixij * uprevij + Iyij * vprevij + Itij)/(lamda^2 + Ixij^2 + Iyij^2));
           v(i,j) = vprevij - Iyij * ((Ixij * uprevij + Iyij * vprevij + Itij)/(lamda^2 + Ixij^2 + Iyij^2));
       end;
    end;
end