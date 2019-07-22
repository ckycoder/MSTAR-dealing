function MSTAR2JPG(sourcePath, targetPath)

if ~exist(targetPath,'dir')

    mkdir(targetPath);

end

Files = dir(sourcePath);%list a file in a folder
for i = 1:length(Files)

    if Files(i).isdir == 0

        FID = fopen([sourcePath '\' Files(i).name],'rb','ieee-be');

        while ~feof(FID)                                % 在PhoenixHeader找到图片尺寸大小

            Text = fgetl(FID);

            if ~isempty(strfind(Text,'NumberOfColumns'))

                ImgColumns = str2double(Text(18:end));
 
                Text = fgetl(FID);

                ImgRows = str2double(Text(15:end));

                break;

            end

        end

        while ~feof(FID)                                 % 跳过PhoenixHeader

            Text = fgetl(FID);

            if ~isempty(strfind(Text,'[EndofPhoenixHeader]'))

                break

            end

        end
        %%clut
%         fseek(FID,512,'cof');
%         Mag = fread(FID,[ImgColumns*ImgRows],'ushort','ieee-be');
%         Img = 6.5608e-4*reshape(Mag,ImgColumns, ImgRows);
%         Img = Img' +1;
%         Img = log10(abs(Img(:,:)) + 1);
%         imwrite(uint8(imadjust(Img)*256),[targetPath '\' Files(i).name(1:end) '.jpg']); % 调整对比度后保存
% 
%         
%         Pha = fread(FID,ImgColumns*ImgRows,'ushort','ieee-be');
%         Imgp = reshape(Pha,[ImgColumns ImgRows]);
%         imwrite(uint8(imadjust(Imgp)*256),[targetPath 'pha\' Files(i).name(1:end) '.jpg']);
       %%chip
        Mag = fread(FID,[ImgColumns*ImgRows],'float32','ieee-be');
        Img = reshape(Mag,[ImgColumns ImgRows]);
        imwrite(uint8(imadjust(Img)*256),[targetPath '\' Files(i).name(1:end-4) '.jpg']);
        
        Pha = fread(FID,ImgColumns*ImgRows,'float32','ieee-be');
        Imgp = reshape(Pha,[ImgColumns ImgRows]);
        imwrite(uint8(imadjust(Imgp)*256),[targetPath 'pha\' Files(i).name(1:end) '.jpg']);  
        clear ImgColumns ImgRows

        fclose(FID);

    else

        if strcmp(Files(i).name,'.') ~= 1 && strcmp(Files(i).name,'..') ~= 1

            if ~exist([targetPath '\' Files(i).name],'dir')

                mkdir([targetPath '\' Files(i).name]);

            end

            MSTAR2JPG([sourcePath '\' Files(i).name],[targetPath '\' Files(i).name]);

        end

    end

end

end