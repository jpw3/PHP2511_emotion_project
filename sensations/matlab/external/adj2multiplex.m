% Convert multiple symmetrical adjacency matrixes to a Pajek multiplex network file
%
% Input
%   - adj : adjacency matrix
%   - name: file name (without extension)
%   - dir : destination directory
%
% Author: Erwan Le Martelot
% Date: 31/05/11

function [] = adj2multiplex(Nadj, name, dir)
    adjtemp=Nadj(:,:,1);
    dst_file = [name,'.net'];
    if nargin == 3
        dst_file = [dir, '/', dst_file];
    end

    fid = fopen(dst_file, 'w');
    
    fprintf(fid, '*Vertices %d\n', length(adjtemp));
    
    for i=1:length(adjtemp)
        fprintf(fid, ' %d "v%d"\n', i, i);
    end
    
    fprintf(fid, '*Multiplex\n');
    
    fprintf(fid, '*Intra\n');
    % # layer node node weight
    for l=1:size(Nadj,3)
        adj=Nadj(:,:,l);
        for i=1:length(adj)
            for j=i+1:length(adj)
                if adj(i,j) > 0
                    fprintf(fid, ' %d %d %d %f\n', l, i, j, adj(i,j));
                end
            end
        end
    end
if(0)
    fprintf(fid, '*Inter\n');
    % # layer node layer weight
    for l1=1:size(Nadj,3)
        for l2=1:size(Nadj,3)
            if(l1==l2) continue; end
            for n=1:size(Nadj,1)
                fprintf(fid, ' %d %d %d %f\n', l1, n, l2, 1);
            end
        end
    end
end
    
    fclose(fid);

end
