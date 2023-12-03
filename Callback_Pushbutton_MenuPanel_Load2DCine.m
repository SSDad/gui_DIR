function Callback_Pushbutton_MenuPanel_Load2DCine(src, evnt)

hFig = ancestor(src, 'Figure');
gData = guidata(hFig);

%% load cine data
td = tempdir;
fd_info = fullfile(td, 'DIR');
ffn_info = fullfile(fd_info, 'info_DIR.mat');
if ~exist(fd_info, 'dir')
    mkdir(fd_info);
end

if ~exist(ffn_info, 'file')
    [dcmPath] = uigetdir();
    save(ffn_info, '*Path');
else
    load(ffn_info);
    [dcmPath] = uigetdir(fileparts(dcmPath));
end

% gData.FileInfo.dcmPath = dcmPath;
% gData.FileInfo.matPath = matPath;

[matPath, dcmFolder] = fileparts(dcmPath);
ffn_mat = fullfile(matPath, [dcmFolder, '.mat']);

if ~exist(ffn_mat, 'file')
    [cineData] = fun_readCineDicom(dcmPath, ffn_mat);
else
    load(ffn_mat);
end

gData.cineData = cineData;

%% cine view
[nImg, mImg, nSlice] = size(cineData.v);
x0 = cineData.IMP(1);
y0 = cineData.IMP(2);
dx = cineData.PS(1);
dy = cineData.PS(2);
xWL(1) = x0-dx/2;
xWL(2) = xWL(1)+dx*nImg;
yWL(1) = y0-dy/2;
yWL(2) = yWL(1)+dy*mImg;
RA = imref2d([mImg nImg], xWL, yWL);
gData.Panel.View.RA(1) = RA;

dy = RA.PixelExtentInWorldX;
dy = RA.PixelExtentInWorldY;
RAGrid.xx = RA.XWorldLimits(1)+dx/2:dx:RA.XWorldLimits(2)-dx/2;
RAGrid.yy = RA.YWorldLimits(1)+dy/2:dy:RA.YWorldLimits(2)-dy/2;
gData.Panel.View.RAGrid = RAGrid;

iSlice = 1;
% axis and image

I{1} = cineData.v(:, :, iSlice);
I{2} = cineData.v(:, :, iSlice+gData.SliceD);

TT{1} = ['Reference - slice  ', num2str(iSlice)];
TT{2} = ['Moving - slice ', num2str(iSlice+gData.SliceD)];
TT{3} = 'Reference (red) and moving (green)';

for iA = 1:6
    hA(iA) = gData.Panel.View.hAxis(iA);
    cla(hA(iA))
    axis(hA(iA), 'tight', 'equal', 'xy');
    hold(hA(iA), "on");
    
    gData.Panel.View.hBB(iA) = line(hA(iA), 'XData', [], 'YData', [], 'Color', 'b');
    gData.Panel.View.hBB(iA).Visible = 'off';

    hA(iA).Title.String = num2str(iA);

end

for iA = 1:2
    gData.Panel.View.hImage(iA) = imshow(I{iA}, RA, [], 'parent', hA(iA));
    hA(iA).Title.String = TT{iA};
end

iA = 3;
C = imfuse(I{1}, I{2});
gData.Panel.View.hImage(iA) = imshow(C, RA, 'parent', hA(iA));
% gData.Panel.View.hImage(iA) = imshowpair(I{1}, RA, I{2}, RA, 'parent', hA(iA));
hA(iA).Title.String = TT{iA};

gData.Panel.View.hImage(4) = imshow(C, RA, 'parent', hA(4));
gData.Panel.View.hImage(5) = imshow(I{1}, RA, [], 'parent', hA(5));
gData.Panel.View.hImage(6) = imshow(C, RA, 'parent', hA(6));

gData.Panel.View.hQV(6) = quiver(hA(6), [], [], [], [], 'g');

junk = [4 5 6];
for n = 1:3
    iA = junk(n);
    gData.Panel.View.hImage(iA).CData = [];
    hA(iA).Title.String = '';
end

% slider
hSS =  gData.Panel.View.hSlider(1);
hSS.Limits = [1 nSlice];
hSS.Value = iSlice;
hSS.Visible = 'on';

hFig.Name = ['DIR   ', dcmPath];

guidata(hFig, gData);


% allFileList = dir(fullfile(matPath, '*.mat'));
% idx = find(contains({allFileList.name}','sag.mat'));
% if ~isempty(idx)
%     fileList{1} = 'sag.mat';
% end
% 
% idx = find(contains({allFileList.name}','cor.mat'));
% if ~isempty(idx)
%     fileList{2} = 'cor.mat';
% end
% 
% idx = find(contains({allFileList.name}','sc.mat'));
% if ~isempty(idx)
%     fileList{3} = 'sc.mat';
% end
% 
% [data.cine.Panel.View.subPanel, data.cine.hAxis] = addComponents2Panel_Cine_View(data.cine.Panel.View.hPanel);
% % data.cine = [];
% %% load data
% bSC = false(4,1);
% ffn = fullfile(matPath, 'sag.mat');
% if exist(ffn, 'file')
%     bSC(1) = 1;
%     load(ffn)
%     data.cine.data(1).v = cineData.v;
%     [data.cine.data(1).mImg, data.cine.data(1).nImg, data.cine.data(1).nSlice] = size(cineData.v);
%     data.cine.data(1).IMP = cineData.IMP;
%     data.cine.data(1).dx = cineData.PS(1);
%     data.cine.data(1).dy = cineData.PS(2);
% 
%     data.cine.data(1).x0 = cineData.IMP(2);
%     data.cine.data(1).y0 = cineData.IMP(3)- data.cine.data(1).dy*data.cine.data(1).mImg;
% %     data.cine.data(1).y0 = cineData.IMP(3);
% 
%     data.cine.data(1).dcmInfo = cineData.dcmInfo;
%     data.cine.Panel.PtInfo.Comp.Text.PtInfo.String = ['MRN - ', cineData.dcmInfo.PatientID];
% 
%     clearvars cineData;
% end
% 
% ffn = fullfile(matPath, 'cor.mat');
% % data.cine(2) = [];
% if exist(ffn, 'file')
%     bSC(2) = 1;
%     load(ffn)
%     data.cine.data(2).v = cineData.v;
%     [data.cine.data(2).mImg, data.cine.data(2).nImg, data.cine.data(2).nSlice] = size(cineData.v);
%     data.cine.data(2).IMP = cineData.IMP;
%     data.cine.data(2).dx = cineData.PS(1);
%     data.cine.data(2).dy = cineData.PS(2);
% 
%     data.cine.data(2).x0 = cineData.IMP(1);
% %     data.cine.data(2).y0 = cineData.IMP(3);
%     data.cine.data(2).y0 = cineData.IMP(3)- data.cine.data(2).dy*data.cine.data(2).mImg;
% 
%     data.cine.data(2).dcmInfo = cineData.dcmInfo;
%     clearvars cineData;
% end
% 
% ffn = fullfile(matPath, 'sc.mat');
% % data.cine(3) = [];
% if exist(ffn, 'file')
%     bSC(3:4) = 1;
%     load(ffn)
%     data.cine.data(3).v = cineData.sag;
%     data.cine.data(4).v = cineData.cor;
%     [data.cine.data(3).mImg, data.cine.data(3).nImg, data.cine.data(3).nSlice] = size(data.cine.data(3).v);
%     [data.cine.data(4).mImg, data.cine.data(4).nImg, data.cine.data(4).nSlice] = size(data.cine.data(4).v);
% 
%     data.cine.data(3).IMP = cineData.imp_sag;
%     data.cine.data(3).dx = cineData.ps_sag(1);
%     data.cine.data(3).dy = cineData.ps_sag(2);
%     data.cine.data(3).x0 = cineData.imp_sag(2);
%     data.cine.data(3).y0 = cineData.imp_sag(3)- data.cine.data(3).dy*data.cine.data(3).mImg;;
% %     data.cine.data(3).y0 = cineData.imp_sag(3);
% 
%     data.cine.data(4).IMP = cineData.imp_cor;
%     data.cine.data(4).dx = cineData.ps_cor(1);
%     data.cine.data(4).dy = cineData.ps_cor(2);
%     data.cine.data(4).x0 = cineData.imp_cor(1);
%     data.cine.data(4).y0 = cineData.imp_cor(3)- data.cine.data(4).dy*data.cine.data(4).mImg;
% %     data.cine.data(4).y0 = cineData.imp_cor(3);
%     clearvars cineData;
% end
% 
% data.cine.bSC = bSC;
% guidata(hFig, data);
% 
% %% view
% SaveFileAppendix{1} = 'sag';
% SaveFileAppendix{2} = 'cor';
% SaveFileAppendix{3} = 'scSag';
% SaveFileAppendix{4} = 'scCor';
% 
% data.cine.ActiveTagNo = [];
% for n = find(bSC)'
%     data.cine.data(n).iSlice = 1;
% 
%     % RA
%     x0 =  data.cine.data(n).x0;
%     y0 = data.cine.data(n).y0;
%     dx = data.cine.data(n).dx;
%     dy = data.cine.data(n).dy;
%     xWL(1) = x0-dx/2;
%     xWL(2) = xWL(1)+dx*data.cine.data(n).nImg;
%     yWL(1) = y0-dy/2;
%     yWL(2) = yWL(1)+dy*data.cine.data(n).mImg;
%     RA = imref2d([data.cine.data(n).mImg data.cine.data(n).nImg], xWL, yWL);
%     data.cine.data(n).RA = RA;
% 
%     % axis and image
%     hA = data.cine.hAxis(n);
%     I = data.cine.data(n).v(:, :, data.cine.data(n).iSlice);
%     I = flipud(I);
%     data.cine.hPlotObj(n).Image = imshow(I, RA, [], 'parent', hA);
%     axis(hA, 'tight', 'equal', 'xy');
% 
% %     y1 = hA.YLim(1);
% %     y2 = hA.YLim(2);
% %     nT = length(hA.YTick);
% %     for iT = 1:nT
% %         y = y1+y2-hA.YTick(iT);
% %         hA.YTickLabel{iT} = num2str(round(y));
% %     end
% 
%     % slider
%     if n < 4
%         hSS =  data.cine.Panel.View.subPanel(n).ssPanel(4).Comp.hSlider.Slice;
%         hSS.Min = 1;
%         hSS.Max = data.cine.data(n).nSlice;
%         hSS.Value = data.cine.data(n).iSlice;
%         hSS.SliderStep = [1 10]/(data.cine.data(n).nSlice-1);
% 
%         data.cine.Panel.View.subPanel(n).ssPanel(4).Comp.hText.nImages.String...
%             = [num2str(data.cine.data(n).iSlice), ' / ', num2str(data.cine.data(n).nSlice)];
% 
%         %contrast
%         yc = histcounts(I, max(I(:))+1);
%         yc = log10(yc);
%         yc = yc/max(yc);
%         xc = 1:length(yc);
%         xc = xc/max(xc);
% 
%          set(data.cine.Panel.View.subPanel(n).ssPanel(2).Comp.hPlotObj.Hist, 'XData', xc, 'YData', yc);
%     end
% 
%     % snake
%     data.cine.hPlotObj(n).Snake = line(hA, 'XData', [], 'YData', [], 'Color', 'm', 'LineStyle', '-', 'LineWidth', 3);
%     data.cine.hPlotObj(n).Snake2 = line(hA, 'XData', [], 'YData', [], 'Color', 'c', 'LineStyle', '-', 'LineWidth', 3);
%     axis(hA, 'tight', 'equal', 'on');
% 
%     % body
%     x0 = data.cine.data(n).x0;
%     y0 = data.cine.data(n).y0;
%     dx = data.cine.data(n).dx;
%     dy = data.cine.data(n).dy;
%     mImgSize = data.cine.data(n).mImg;
%     nImgSize = data.cine.data(n).nImg;
%     xWL(1) = x0;
%     xWL(2) = xWL(1)+dx*nImgSize;
%     yWL(1) = y0-dy/2;
%     yWL(2) = yWL(1)+dy*mImgSize;
% 
%     data.cine.hPlotObj(n).Body = line(hA, 'XData', [], 'YData', [], 'Color', 'g', 'LineStyle', '-', 'LineWidth', 0.5);
%     data.cine.hPlotObj(n).Ab = line(hA,  'XData', [], 'YData', [], 'Color', 'g', 'LineStyle', '-', 'LineWidth', 3, 'Marker', '.');
% 
% %     pos = [x0 y0+yWL(2)*2/3
% %             xWL(2) y0+yWL(2)*2/3];
% %     hPlotObj.AbLine1 = images.roi.Line(hA, 'Color', 'g', 'Position', pos, 'LineWidth', 0.5,...
% %         'Tag', 'L1', 'InteractionsAllowed', 'Translate');
% %    addlistener(hPlotObj.AbLine1, 'MovingROI', @Callback_Line_AbL1);
% 
% %     pos = [ x0  y0+yWL(2)/3 xWL(2) yWL(2)/3];
% %     hPlotObj.AbRect = images.roi.Rectangle(hA, 'Position', pos, 'Color', 'g',...
% %         'LineWidth', .5, 'FaceAlpha', 0.1, 'Tag', 'AbRec', 'Visible', 'off');
% %     addlistener(hPlotObj.AbRect, 'MovingROI', @Callback_AbRect_Cine_);
% 
% %     x1 = pos(1);
% %     x2 = x1+pos(3);
% %     y1 = pos(2)+pos(4)/2;
% %     y2 = y1;
% %     hPlotObj.AbRectCLine = images.roi.Line(hA, 'Position',[x1 y1; x2 y2], 'Color', 'c',...
% %         'LineWidth', 1, 'Tag', 'AbRecCLine', 'Visible', 'off');
% %     addlistener(hPlotObj.AbRectCLine, 'MovingROI', @Callback_AbRectCLine);
% 
%     % tumor
%     data.cine.hPlotObj(n).Tumor = line(hA, 'XData', [], 'YData', [], 'Color', 'c', 'LineStyle', '-', 'LineWidth', 3);
% 
%      % save file names
%      data.cine.data(n).ffn_Snake_mat = fullfile(data.FileInfo.CineMatPath, ['Snake_', SaveFileAppendix{n}, '.mat']);
%      data.cine.data(n).ffn_Snake_csv = fullfile(data.FileInfo.CineMatPath, ['SnakePointsMatrix_', SaveFileAppendix{n}, '.csv']);
% 
%      data.cine.data(n).ffn_Tumor_mat = fullfile(data.FileInfo.CineMatPath, ['Tumor_', SaveFileAppendix{n}, '.mat']);
%      data.cine.data(n).ffn_Tumor_csv = fullfile(data.FileInfo.CineMatPath, ['TumorPointsMatrix_', SaveFileAppendix{n}, '.csv']);
% 
%       data.cine.data(n).ffn_Body_mat = fullfile(data.FileInfo.CineMatPath, ['Ab_', SaveFileAppendix{n}, '.mat']);
%      data.cine.data(n).ffn_Body_csv = fullfile(data.FileInfo.CineMatPath, ['AbPointsMatrix_', SaveFileAppendix{n}, '.csv']);
% 
%      % enable zoom button
%     data.cine.Panel.View.subPanel(n).ssPanel(1).Comp.Pushbutton.Zoom.Enable = 'on';
% end
% 
% % %buttons on Snake
% % data.Panel.Snake.Comp.Pushbutton.FreeHand.Enable = 'on';
% % data.Panel.Snake.Comp.Pushbutton.StartSlice.Enable = 'on';
% % data.Panel.Snake.Comp.Pushbutton.EndSlice.Enable = 'on';
% % data.Panel.Snake.Comp.Edit.StartSlice.ForegroundColor = 'r';
% % data.Panel.Snake.Comp.Edit.EndSlice.ForegroundColor = 'r';
% % 
% % %buttons on Body
% % data.Panel.Body.Comp.Pushbutton.Contour.Enable = 'on';
% % data.Panel.Body.Comp.Togglebutton.Boundary.Enable = 'on';
% 
% % LoadContour button
% data.cine.Panel.LoadImage.Comp.Pushbutton.LoadContour.Enable = 'on';
% data.cine.Panel.LoadImage.Comp.Pushbutton.SavePDF.Enable = 'on';
% 
% for n = 1:4
%     data.cine.data(n).bContourLoaded = 0;
% end
% 
% guidata(hFig, data);