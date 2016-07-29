function o = BubbleMovie(o)

% function o = BubbleMovie(o)
%
% this function makes a bubble movie. that's about it.  Straight ripped off
% of QuickBubblePlots and mildly updated for new RunQA2.  Instead of really
% modifing this and trying to make it better, I am leaving it as it was for
% maximum stability.

SaveDataPath = [o.Paths.save.bubble filesep];

% Chunk up data into 100 pt averages
R1 = 100;
% Higher resolution bubble movies for Beta39
% if strcmp(o.run.beta,'B000039')
%     R1 = 10;
% end
R2 = floor(size(o.MI,2)/R1);
Reads.Start_idx = [1:R1:R1*R2]';
Reads.End_idx = [R1:R1:R1*R2]';

tic
f = figure('visible','off');
for ind=1:length(Reads.Start_idx)
    pause(0.01)
    t_Md = single(mean(o.MI(:,Reads.Start_idx(ind):Reads.End_idx(ind)),2));
    imagesc(reshape(t_Md,1024,o.chip.number_of_rows)');
    title(['Frame ' num2str(ind)])
    saveas(gcf,[SaveDataPath 'BubCheck' num2str(ind,'%04d') '.png']);
end

f = figure('visible','on');
close all
toc

PNApath = [SaveDataPath 'BubCheck%04d.png '];
MOVIEPath = [SaveDataPath(1:end-7) o.run.id '-BubbleMovie.avi'];
sysString = ['ffmpeg -y -qscale 5 -r 20 -b 9600 -i ' PNApath MOVIEPath];
system(sysString)