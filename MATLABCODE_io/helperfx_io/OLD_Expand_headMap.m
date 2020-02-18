S=size(annot,1);
ehmap=[];
%%
for s=1:S
   nseg=round([annot(s,2)-annot(s,1)]/(1024*30));
   rs=repmat(hmap(:,s),1,nseg);
   ehmap=[ehmap rs];
end