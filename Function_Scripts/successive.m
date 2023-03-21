function bool = successive(a)
% Determines if all the numbers in a given input 1D array are successive
% integers. 
% 
      assert((size(a,1)==1 || size(a,2)==1) && isa(a,'double'));
      a = sort(a);
      bool = (abs(max(a)-min(a))+1)==numel(a);
end