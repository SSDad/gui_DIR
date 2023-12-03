function gui_DIR

%% fig
xL = 3/4;
yL = 3/4;
x0 = (1-xL)/2;
y0 = (1-yL)/2;
hFig = uifigure( 'Units', 'normalized', 'Position', [x0 y0 xL yL]);
hFig.Name = "DIR";

% % Create a File menu
% fileMenu = uimenu(fig, 'Text', 'File');
% % Add menu items to the File menu
% uimenu(fileMenu, 'Text', 'New', 'MenuSelectedFcn', @(src, event) disp('New selected'));
% uimenu(fileMenu, 'Text', 'Open', 'MenuSelectedFcn', @(src, event) disp('Open selected'));
% uimenu(fileMenu, 'Text', 'Save', 'MenuSelectedFcn', @(src, event) disp('Save selected'));
% uimenu(fileMenu, 'Text', 'Save As', 'MenuSelectedFcn', @(src, event) disp('Save As selected'));

%% grid and panel

gData.Panel = addPanel(hFig);
gData.Panel.Menu.Comp = addComp2Panel_Menu(gData.Panel.Menu.hPanel);
[gData.Panel.View.hSubPanel, gData.Panel.View.hAxis, gData.Panel.View.hSlider] = ...
                        addComp2Panel_View(gData.Panel.View.hPanel);

gData.SliceD = 10;
gData.iSlice = 1;

guidata(hFig, gData);