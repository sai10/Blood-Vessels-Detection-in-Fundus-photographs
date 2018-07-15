function [Mask] = find_mask(I)
  %   A function finding the mask for retinal images
  % 1=Masked points
  % 0=Signal points

  if max(I)<=1
      I = I*255;
  end

  Black = I<10;
  White = I>245;
  Mask  = Black | White;
  
  se = strel('disk',1);
  
  % Action:
  for i=1:12
    Mask = imdilate(Mask,se);
  end
