function varargout = capstonegui(varargin)
% UNTITLED MATLAB code for untitled.fig
%      UNTITLED, by itself, creates a new UNTITLED or raises the existing
%      singleton*.
%
%      H = UNTITLED returns the handle to a new UNTITLED or the handle to
%      the existing singleton*.
%
%      UNTITLED('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UNTITLED.M with the given input arguments.
%
%      UNTITLED('Property','Value',...) creates a new UNTITLED or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before untitled_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to untitled_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help untitled

% Last Modified by GUIDE v2.5 27-Mar-2019 14:44:11

% Begin initialization code - DO NOT EDIT
% Rdata_global = varargin{1};
% assignin('base','Rdata_global',Rdata_global)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @untitled_OpeningFcn, ...
    'gui_OutputFcn',  @untitled_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before untitled is made visible.
function untitled_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to untitled (see VARARGIN)

% Choose default command line output for untitled
handles.output = hObject;

% Update handles structure
if strcmp(get(hObject,'Visible'),'off')
    plot(rand(5));
end
% check the state if it the first time imaging or the last time
handles.isImaging = false;
handles.imagingFirstStart = false;
guidata(hObject, handles);
assignin('base','isImaging',0);
assignin('base','Live3D',0);
% store the handles to the gui workspace
save('temp.mat','handles');
assignin('base','gui_handles',handles);



% --- Outputs from this function are returned to the command line.
function varargout = untitled_OutputFcn(hObject, eventdata, handles)

varargout{1} = handles.output;

function plot_xslice()

% load the handles from gui workspace to matlab work space
handles = load('temp.mat');
xvalue=get(handles.handles.edit6,'String');%
xslices=str2double(xvalue);
% obtain image data from the work sapce
bf_data = evalin('base','bf_data');
bf_data = abs(double(bf_data(:,:,:)));
% plot data
axes(handles.handles.axes1);
cla;
imagesc(20*log10(abs(hilbert(squeeze(bf_data(1:5000,xslices,:))))))



function plot_yslice()

% obtain handles from work space
handles = load('temp.mat');
yvalue=get(handles.handles.edit7,'String');%
yslices=str2double(yvalue);
bf_data = evalin('base','bf_data');
bf_data = abs(double(bf_data(:,:,:)));
% plot the data
axes(handles.handles.axes2);
cla;
imagesc(20*log10(abs(hilbert(squeeze(bf_data(1:5000,:,yslices))))))

function imaging_plot3d()
% load current handles value to the work space
handles = load('temp.mat');
% obtain the user input slice number from the interface and load the data
% to the work space
axes(handles.handles.axes3);
cla;
xvalue=get(handles.handles.edit6,'String');
xslices=str2double(xvalue);
yvalue=get(handles.handles.edit7,'String');
yslices=str2double(yvalue);
bfImage_3d = evalin('base','bfImage_3d');
% construct image mesh grid to plot the data
xaxis=1:151;
yaxis=1:evalin('base','N_elev');
zaxis=1:1500;
[x,z]=meshgrid(xaxis,zaxis);
if(length(yslices)==1)
    % when user only select one slice of image to plot
    y=yaxis(yslices).*ones(size(x));
%mesh(...,C) draws a wireframe mesh with color determined by matrix C. 
%MATLAB® performs a linear transformation on the data in C to obtain colors from the current colormap.
%If X, Y, and Z are matrices, they must be the same size as C.
    C = squeeze(bfImage_3d(:,:,yslices));
    h=mesh(x,y,z,double(C.*255));
    colormap('gray');
    caxis([0 1]);
 
    hold on
else
    %when user select multiple slices to plot
    lengthy=length(yslices);
    for i =1:lengthy
        y=yaxis(yslices(i)).*ones(size(x));
        C = squeeze(bfImage_3d(:,:,yslices(i)));
        h=mesh(x,y,z,double(C.*255));
     hold on
    end
end

    [y2,z2]=meshgrid(yaxis,zaxis);
if(length(xslices)==1)
     % when user only select one slice of image to plot
    x2=xaxis(xslices).*ones(size(y2));
    C2 = squeeze(bfImage_3d(:,xslices,:));
    h=mesh(x2,y2,z2,double(C2.*255));
    colormap('gray');
    caxis([0 1]);
    
    hold on
else
    %when user select multiple slices of images to plot
    lengthx=length(xslices);
    for i =1:lengthx
        x2=xaxis(xslices(i)).*ones(size(y2));
    
        C2 = squeeze(bfImage_3d(:,xslices(i),:));


        h=mesh(x2,y2,z2,double(C2.*255));
        
        hold on
        pause(2)
    end
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Rdata = evalin('base','Rdata');
Rdata = abs(double(Rdata(:,:,:)));
guidata(hObject, handles);
axes(handles.axes1);
cla;
imagesc(20*log10(abs(squeeze(double(Rdata(1:5000,:,1))))));

function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
guidata(hObject, handles);
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double
% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function text1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in StartImaging_button.
function StartImaging_button_Callback(hObject, eventdata, handles)
% hObject    handle to StartImaging_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if (handles.imagingFirstStart == 0)
    % take the user input parameters values from the user interface
    set(handles.StartImaging_button,'String','Stop Imaging');
    handles.imagingFirstStart = 1;
    guidata(hObject, handles);
    set(handles.isImaging_radio,'value',1);
    Resource.Parameters.numTransmit = str2double(get(handles.edit5,'String')); % no. of transmit channels (2 brds).
    Resource.Parameters.numRcvChannels =str2double(get(handles.edit1,'String')); % no. of receive channels (2 brds).
    Resource.Parameters.speedOfSound = str2double(get( handles.edit2,'String')); % speed of sound in m/sec
    Resource.Parameters.simulateMode = str2double(get( handles.edit3,'String')); % runs script in simulate mod
 % when first time the program is started,first3d is initialized as 1
    first3d=1;
 % threed plot is initlized as zero
    threed = 0;
 %three D in real time parameter is initialized as 0
    Live3D = 0;
 %store above parameters values to the work space
    assignin('base','first3d',first3d);
    assignin('base','threed',threed);
    assignin('base','Live3D',Live3D);
    save('parameters.mat','Parameters');
 % run the setup file to set up versonic system
    run('FORCES_PZT_64x64_split2_Capstone.m');
    evalin('base','filename = ''FORCES_PZT_64x64split_Capstone.mat'';VSX;');
    assignin('base','gui_handles',handles);
 % stop imaging button is pressed
elseif (get(handles.isImaging_radio,'value') == 0)
    set(handles.StartImaging_button,'String','Stop Imaging');
    handles.isImaging = true;
    assignin('base','isImaging',1);
    set(handles.isImaging_radio,'value',1);
    guidata(hObject, handles);
    assignin('base','isImaging',1);
% start imaging button is pressed   
elseif (get(handles.isImaging_radio,'value') == 1)
    set(handles.StartImaging_button,'String','Start Imaging');
    handles.isImaging = false;
    guidata(hObject, handles);
    set(handles.isImaging_radio,'value',0);
    assignin('base','isImaging',0);
end

function edit3_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function text4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object deletion, before destroying properties.
function edit4_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%stop imaging
fprintf('Cleared Plotting\n');
axes(handles.axes1);
cla;
axes(handles.axes2);
cla;
axes(handles.axes3);
cla;



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider4_Callback(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in isImaging_radio.
function isImaging_radio_Callback(hObject, eventdata, handles)
% hObject    handle to isImaging_radio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of isImaging_radio


% --- Executes on button press in pushbutton5.
% function pushbutton5_Callback(hObject, eventdata, handles)
% % hObject    handle to pushbutton5 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% % THIS FUNCTION WORKS FOR OFFLINE IMAGE DATA PLOTTING
% % start imaging button is pressed
% % load image data
% load('ultrasound_wire_sample_data (1).mat');
% xvalue=get(handles.edit6,'String');%
% xslices=str2num(xvalue);
% yvalue=get(handles.edit7,'String');
% yslices=str2num(yvalue);
% Rdata = bf_image_norm;
% handles.Rdata=Rdata;
% assignin('base','Rdata_global',Rdata);
% assignin('base','xslices',xslices);
% assignin('base','yslices',yslices);
% guidata(hObject, handles);
%LOCAL CONTRAST FUNCTION WORKS TO ENHANCE THE BRIGHTNESS OF THE IMAGE
% amount=0;
% edgecontrast= 0;
% if(length(xslices)<=length(yslices))
%     
%     for i=1:length(xslices)
%         axes(handles.axes1);
%         cla;
%         h=imagesc((((squeeze(double(Rdata(:,:,xslices(i))))))));
%         B = localcontrast(uint8(repmat(h.CData,1,1,3)*255), edgecontrast, amount);
%         imagesc(B);
%         colorbar;
%         
%         axes(handles.axes2);
%         cla;
%         h=imagesc((((squeeze(double(Rdata(:,yslices(i),:)))))));
%         B = localcontrast(uint8(repmat(h.CData,1,1,3)*255), edgecontrast, amount);
%         imagesc(B);
%         colorbar
%         
%     end
%     for j=i:length(yslices)
%         axes(handles.axes2);
%         cla;
%         h=imagesc((((squeeze(double(Rdata(:,yslices(j),:)))))));
%         B = localcontrast(uint8(repmat(h.CData,1,1,3)*255), edgecontrast, amount);
%         imagesc(B);
%         colorbar
%     end
%     
% else
%     for i=1:length(yslices)
%         axes(handles.axes1);
%         cla;
%         h=imagesc(((squeeze(double(Rdata(:,:,xslices(i)))))));
%         B = localcontrast(uint8(repmat(h.CData,1,1,3)*255), edgecontrast, amount);
%         imagesc(B);
%         colorbar;
%         
%         axes(handles.axes2);
%         cla;
%         h=imagesc(((squeeze(double(Rdata(:,yslices(i),:))))));
%         B = localcontrast(uint8(repmat(h.CData,1,1,3)*255), edgecontrast, amount);
%         imagesc(B);
%         colorbar
%         
%     end
%     for j=i:length(xslices)
%         axes(handles.axes1);
%         cla;
%         h=imagesc(((squeeze(double(Rdata(:,:,xslices(i)))))));
%         B = localcontrast(uint8(repmat(h.CData,1,1,3)*255), edgecontrast, amount);
%         imagesc(B);
%         colorbar
%     end
% end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%PLOT 3d IMAGE IN REAL TIME
axes(handles.axes3);
cla;
threed=1;
assignin('base','threed',threed);
imaging_plot3d();
%IMAGE PLOT 3D FOR OFFLINE DATA
% function plotin3d()
% rotate3d on
% Rdata = evalin('base','Rdata_global');
% xslices = evalin('base','xslices');
% yslices = evalin('base','yslices');
% xaxis=1:size(Rdata,2);
% yaxis=1:size(Rdata,3);
% zaxis=1:size(Rdata,1);
% [x,z]=meshgrid(xaxis,zaxis);
% if(length(yslices)==1)
%     y=yaxis(yslices).*ones(size(x));
%   
%     C = squeeze(Rdata(:,:,yslices));
%     G=zeros(size(C));
%     G=C>=mean(mean(Rdata(:,:,yslices)))+max(max(std(Rdata(:,:,yslices))));
%     h=mesh(x,y,z,double(C.*G.*255));
% 
%     hold on
% else
%     lengthy=length(yslices);
%     for i =1:lengthy
%         y=yaxis(yslices(i)).*ones(size(x));
%      
%         G=zeros(size(C));
%         C = squeeze(Rdata(:,:,yslices(i)));
%         G=C>=mean(mean(Rdata(:,:,yslices(i))))+max(max(std(Rdata(:,:,yslices(i)))));
%         h=mesh(x,y,z,double(C.*G.*255));
%      
%         hold on
%         pause(2)
%     end
% end
% 
% [y2,z2]=meshgrid(yaxis,zaxis);
% if(length(xslices)==1)
%     x2=xaxis(xslices).*ones(size(y2));
% 
%     C2 = squeeze(Rdata(:,xslices,:));
%     G=zeros(size(C2));
% 
%     G=C2>=mean(mean(Rdata(:,xslices,:)))+max(max(std(Rdata(:,xslices,:))));
%     h=mesh(x2,y2,z2,double(C2.*G.*255));
% 
%     hold on
% else
%     lengthx=length(xslices);
%     for i =1:lengthx
%         x2=xaxis(xslices(i)).*ones(size(y2));
%  C2 = squeeze(Rdata(:,xslices(i),:));
%         G=zeros(size(C2));
%       G=C2>=mean(mean(Rdata(:,xslices(i),:)))+max(max(std(Rdata(:,xslices(i),:))));
%         h=mesh(x2,y2,z2,double(C2.*G.*255));
%         hold on
%         pause(2)
%     end
% end
% PLOTIMAGEFUNCTION WORKS FOR OFFLINE DATA
% function plotimagefunction()
% handles=evalin('base','gui_handles');
% Rdata_global=evalin('base','Rdata_global');
% xvalue=get(handles.edit6,'String');
% xslices=str2num(xvalue);
% yvalue=get(handles.edit7,'String');
% yslices=str2num(yvalue);
% Rdata = Rdata_global;
% 
% Rdata = abs(double(Rdata(:,:,:)));
% assignin('base','Rdata_global',Rdata);
% assignin('base','xslices',xslices);
% assignin('base','yslices',yslices);
% amount=evalin('base','amount');
% edgecontrast= evalin('base','edgecontrast');
% 
% if(length(xslices)<=length(yslices))
%     
%     for i=1:length(xslices)
%         axes(handles.axes1);
%         cla;
%         h=imagesc((((squeeze(double(Rdata(:,:,xslices(i))))))));
%         B = localcontrast(uint8(repmat(h.CData,1,1,3)*255), edgecontrast, amount);
%         imagesc(B);
%         colorbar;
%         
%         axes(handles.axes2);
%         cla;
%         h=imagesc((((squeeze(double(Rdata(:,yslices(i),:)))))));
%         B = localcontrast(uint8(repmat(h.CData,1,1,3)*255), edgecontrast, amount);
%         imagesc(B);
%         colorbar;
%         
%     end
%     for j=i:length(yslices)
%         axes(handles.axes2);
%         cla;
%         h=imagesc((((squeeze(double(Rdata(:,yslices(j),:)))))));
%         B = localcontrast(uint8(repmat(h.CData,1,1,3)*255), edgecontrast, amount);
%         imagesc(B)
%         colorbar;
%     end
%     
% else
%     for i=1:length(yslices)
%         axes(handles.axes1);
%         cla;
%         h=imagesc(((squeeze(double(Rdata(:,:,xslices(i)))))));
%         B = localcontrast(uint8(repmat(h.CData,1,1,3)*255), edgecontrast, amount);
%         imagesc(B)
%         colorbar;
%         
%         axes(handles.axes2);
%         cla;
%         h=imagesc(((squeeze(double(Rdata(:,yslices(i),:))))));
%         B = localcontrast(uint8(repmat(h.CData,1,1,3)*255), edgecontrast, amount);
%         imagesc(B)
%         colorbar;
%         
%     end
%     for j=i:length(xslices)
%         axes(handles.axes1);
%         cla;
%         h=imagesc(((squeeze(double(Rdata(:,:,xslices(i)))))));
%         B = localcontrast(uint8(repmat(h.CData,1,1,3)*255), edgecontrast, amount);
%         imagesc(B)
%         colorbar;
%     end
% end



% --- Executes on slider movement.
function slider7_Callback(hObject, eventdata, handles)
% hObject    handle to slider7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider8_Callback(hObject, eventdata, handles)
% hObject    handle to slider8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Caxis=get(hObject,'Value');
assignin('base','Caxis',Caxis);
set(handles.edit9,'string',num2str(Caxis));



% --- Executes during object creation, after setting all properties.
function slider8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider9_Callback(hObject, eventdata, handles)
% hObject    handle to slider9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axiesview=handles.axes3;
angle=get(hObject,'Value');
view(axiesview ,[angle 30]);



% --- Executes during object creation, after setting all properties.
function slider9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider10_Callback(hObject, eventdata, handles)
% hObject    handle to slider10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.edit10,'string',num2str(get(hObject,'Value')));
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(evalin('base','Live3D'))
    assignin('base','Live3D',0)
    set(handles.pushbutton7,'String','3D Live On');
else
    assignin('base','Live3D',1)
    set(handles.pushbutton7,'String','3D Live Off');
end


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
implay('VID_20190401_142035.mp4');
