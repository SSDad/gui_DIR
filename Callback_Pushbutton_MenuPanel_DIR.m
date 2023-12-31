function Callback_Pushbutton_MenuPanel_DIR(src, evnt)

hFig = ancestor(src, 'Figure');
gData = guidata(hFig);

%% DIR
iSlice = round(gData.Panel.View.hSlider(1).Value);
img_fixed = gData.cineData.v(:,:,iSlice);
img_moving = gData.cineData.v(:,:,iSlice+gData.SliceD);

[dispField, img_reg]=imregdeform(img_moving, img_fixed);
gData.Panel.View.hImage(5).CData = img_reg;
gData.Panel.View.hImage(5).Visible = 'on';
gData.Panel.View.hAxis(5).Title.String = ['Moving Deformed'];

C = imfuse(img_fixed, img_reg);
gData.Panel.View.hImage(4).CData = C;
gData.Panel.View.hImage(4).Visible = 'on';
gData.Panel.View.hAxis(4).Title.String = ['Reference and Deformed'];

C = imfuse(img_reg, img_moving);
gData.Panel.View.hImage(6).CData = C;
gData.Panel.View.hImage(6).Visible = 'on';
gData.Panel.View.hAxis(6).Title.String = ['DVF'];

RA = gData.Panel.View.RA(1);
xx = gData.Panel.View.RAGrid.xx;
yy = gData.Panel.View.RAGrid.yy;
s = 4;
xx = xx(1:s:end);
yy = yy(1:s:end);
[xg, yg] = meshgrid(xx, yy);

dx = RA.PixelExtentInWorldX;
dy = RA.PixelExtentInWorldY;
U = dispField(:,:,1) * dy;
V = dispField(:,:,2) * dx;
U = U(1:s:end, 1:s:end);
V = V(1:s:end, 1:s:end);

% body mask
J = rescale(img_moving);
T = graythresh(J);
BW = imbinarize(J, T/16);
BW = imfill(BW, 'holes');
se = strel('disk', 2);
BW = imerode(BW, se);
B = bwboundaries(BW);
nn = B{1}(:, 1);
mm = B{1}(:, 2);
[xx, yy] = intrinsicToWorld(RA, mm, nn);

set(gData.Panel.View.hBB(6), 'XData', xx, 'YData', yy);

%% inside polygon
[ind] = inpolygon(xg, yg, xx, yy);
U(~ind) = 0;
V(~ind) = 0;

%% quiver
set(gData.Panel.View.hQV(6), 'XData', xg+U, 'YData', yg+V, 'UData', -U, 'VData', -V);
gData.Panel.View.hQV(6).Visible = 'on';

guidata(hFig, gData);

% quiver(hA4, xg+U, yg+V, -U, -V, 'r', 'AutoScale', 'off');


% 
% 
% hA = gData.Panel.View.hAxis(2);
% gData.Panel.View.Image(2) = imshow(flipud(img_moving), RA, [], 'parent', hA);
% axis(hA, 'tight', 'equal', 'xy');
% 
% hA = gData.Panel.View.hAxis(3);
% gData.Panel.View.Image(3) = imshow(flipud(img_reg), RA, [], 'parent', hA);
% axis(hA, 'tight', 'equal', 'xy');



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