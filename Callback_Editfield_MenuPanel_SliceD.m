function Callback_Editfield_MenuPanel_SliceD(src, evnt)

hFig = ancestor(src, 'Figure');
gData = guidata(hFig);

gData.SliceD = src.Value;

J = gData.cineData.v(:, :, gData.iSlice+gData.SliceD);
gData.Panel.View.hImage(2).CData = J;
gData.Panel.View.hAxis(2).Title.String = ['slice - ', num2str(gData.iSlice+gData.SliceD)];;

gData.Panel.View.hImage(3).CData = gData.Panel.View.hImage(1).CData;
gData.Panel.View.hAxis(3).Title.String = gData.Panel.View.hAxis(1).Title.String;

gData.Panel.View.hImage(4).CData = J;
gData.Panel.View.hAxis(4).Title.String = ['slice - ', num2str(gData.iSlice+gData.SliceD)];;
gData.Panel.View.hQV(4).Visible = 'off';

guidata(hFig, gData)