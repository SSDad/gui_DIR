function [Panel] = addPanel(hFig)

gl = uigridlayout(hFig, [1 2]);
gl.ColumnWidth = {'1x','6x'};

%% panel
Panel.Menu.hPanel = uipanel(gl);
Panel.View.hPanel = uipanel(gl);

Panel.Menu.hPanel.Layout.Row = 1;
Panel.Menu.hPanel.Layout.Column = 1;
Panel.Menu.hPanel.BackgroundColor = 'k';

Panel.View.hView.Layout.Row = 1;
Panel.View.hView.Layout.Column = 2;
Panel.View.hView.BackgroundColor = 'k';