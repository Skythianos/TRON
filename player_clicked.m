function player_clicked(source,eventdata)
keyPressed = eventdata.Key;
        global player_dir_p1
        global player_dir_p2
        % If the w,a,s or d or one of the arrows is pressed
        switch keyPressed
            %   w(1) -> up
            %   s(3) -> down
            %   d(2) -> right
            %   a(4) -> left
            % Because of the matrix indexing and transformation chanses
            % have to be made
            case 'w'
                dir_temp_p1 = 1;
                if abs(dir_temp_p1 - player_dir_p1) ~= 2
                    player_dir_p1 = dir_temp_p1;
                end                
            case 's'
                dir_temp_p1 = 3;
                if abs(dir_temp_p1 - player_dir_p1) ~= 2
                    player_dir_p1 = dir_temp_p1;
                end     
            case 'd'
                dir_temp_p1 = 4;
                if abs(dir_temp_p1 - player_dir_p1) ~= 2
                    player_dir_p1 = dir_temp_p1;
                end     
            case 'a'
                dir_temp_p1 = 2;
                if abs(dir_temp_p1 - player_dir_p1) ~= 2
                    player_dir_p1 = dir_temp_p1;
                end
            %%%%% player 2
            case 'uparrow'
                dir_temp_p2 = 1;
                if abs(dir_temp_p2 - player_dir_p2) ~= 2
                    player_dir_p2 = dir_temp_p2;
                end                
            case 'rightarrow'
                dir_temp_p2 = 4;
                if abs(dir_temp_p2 - player_dir_p2) ~= 2
                    player_dir_p2 = dir_temp_p2;
                end     
            case 'leftarrow'
                dir_temp_p2 = 2;
                if abs(dir_temp_p2 - player_dir_p2) ~= 2
                    player_dir_p2 = dir_temp_p2;
                end     
            case 'downarrow'
                dir_temp_p2 = 3;
                if abs(dir_temp_p2 - player_dir_p2) ~= 2
                    player_dir_p2 = dir_temp_p2;
                end
            %%%%%
            otherwise
                return;
        end
end