function plotBBox(im,BBoxes,translate)
n = size(BBoxes);
target = 'x';
figure
imshow(im);
hold on;
for x = 1:n(1)
   if rem(x,2) > 0
       target = 'ro';
   else
       target = '^g';
   end
   BBox = BBoxes(x).BoundingBox;
   plot(BBox(1)+10,BBox(2)+10,target);
   plot(BBox(1)+BBox(3)+10,BBox(2)+10,target);
   plot(BBox(1)+10,BBox(2)+BBox(4)+10,target);
   plot(BBox(1)+BBox(3)+10,BBox(2)+BBox(4)+10,target);
end
hold off;
end