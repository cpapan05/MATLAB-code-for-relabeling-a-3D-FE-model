clear all
close all
clc

% In this poit user adds the points and the nodes for the first geometry as txt file

nodes=dlmread('brain nodes.txt');
elements= dlmread('brain points.txt');

elements(:,1)=[];
% In this point program checks seperates the nodes by their ID as this was
% given to them by gmsh and makes a file only with those they have the
% preffered ID
k=nodes(:,4) ;
for i=1:length(k)
   if k(i)==3000 || k(i)==3001 || k(i)==3002
       d(i)=i;
   end   
end
d(d==0)=[];

%In this part program calculates the coordinates for every node of the first
%geometry
for i=1:length(d)
brain_nodes(i,[1:4])=nodes(d(i),[6:9]);
end
brain_nodes;
x_coordinates_of_elements=elements((brain_nodes),1);
y_coordinates_of_elements=elements((brain_nodes),2);       
z_coordinates_of_elements=elements((brain_nodes),3);

% In this part program calculates the geometrical center for the first
% geometry
x_coordinates_of_elements=reshape(x_coordinates_of_elements,i,4);
mean_x_elements=mean(x_coordinates_of_elements,2);
y_coordinates_of_elements=reshape(y_coordinates_of_elements,i,4);
mean_y_elements=mean(y_coordinates_of_elements,2);
z_coordinates_of_elements=reshape(z_coordinates_of_elements,i,4);
mean_z_elements=mean(z_coordinates_of_elements,2);
geometrical_center_of_particles=[mean_x_elements,mean_y_elements,mean_z_elements];

%In this user adds the second geometry as STL file
white_matter=stlread('tumor.stl');
white_matter_elements=white_matter.Points;
white_matter_nodes=white_matter.ConnectivityList;

%In this part program calculates the coordinates for every node of the
%second geometry
x_coordinates_of_white_matter_elements=white_matter_elements((white_matter_nodes),1);
y_coordinates_of_white_matter_elements=white_matter_elements((white_matter_nodes),2);       
z_coordinates_of_white_matter_elements=white_matter_elements((white_matter_nodes),3);
for j=1:length(white_matter_nodes);
end

% In this part program calculates the geometrical center for the second
% geometry
x_coordinates_of_white_matter_elements=reshape(x_coordinates_of_white_matter_elements,j,3);
mean_x_white_matter_elements=mean(x_coordinates_of_white_matter_elements,2);
y_coordinates_of_white_matter_elements=reshape(y_coordinates_of_white_matter_elements,j,3);
mean_y_white_matter_elements=mean(y_coordinates_of_white_matter_elements,2);
z_coordinates_of_white_matter_elements=reshape(z_coordinates_of_white_matter_elements,j,3);
mean_z_white_matter_elements=mean(z_coordinates_of_white_matter_elements,2);
geometrical_center_of_white_matter_elements=[mean_x_white_matter_elements,mean_y_white_matter_elements,mean_z_white_matter_elements];

%In this part code checks if any node of the second geometry are
%inside the first one
shp = alphaShape(mean_x_white_matter_elements, mean_y_white_matter_elements, mean_z_white_matter_elements);
tf = inShape(shp,mean_x_elements, mean_y_elements,mean_z_elements); 
brain_segmented=nodes;

%In this part codes change the ID of the nodes of the first geometry that
%belong to the second one also
for j=1:1:length(tf)
  if tf(j)>0
     brain_segmented(j,4)=3004;
     brain_segmented(j,5)=6;

  end
end  
%In this part code creates a new txt file that contains every node with its
%new ID.
dlmwrite('segments.txt',brain_segmented,'delimiter','\t','precision',8)

