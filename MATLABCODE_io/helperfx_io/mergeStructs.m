%AT 4/24/20; fx works for what I need it to do



function [merged_struct] = mergeStructs(struct_a,struct_b)
%%if one of the structres is empty do not merge
if isempty(struct_a)
    merged_struct=struct_b;
    return
end
if isempty(struct_b)
    merged_struct=struct_a;
    return
end
%%insert struct a
merged_struct=struct_a;
%%insert struct b
size_a=length(merged_struct);
for j=1:length(struct_b)
    f = fieldnames(struct_b);
    for i = 1:length(f)
        merged_struct(size_a+j).(f{i}) = struct_b(j).(f{i});
    end
end