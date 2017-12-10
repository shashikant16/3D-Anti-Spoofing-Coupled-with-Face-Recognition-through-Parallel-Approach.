function varargout = MainWindow(varargin)
% MAINWINDOW MATLAB code for MainWindow.fig
%      MAINWINDOW, by itself, creates a new MAINWINDOW or raises the existing
%      singleton*.
%
%      H = MAINWINDOW returns the handle to a new MAINWINDOW or the handle to
%      the existing singleton*.
%
%      MAINWINDOW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAINWINDOW.M with the given input arguments.
%
%      MAINWINDOW('Property','Value',...) creates a new MAINWINDOW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MainWindow_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MainWindow_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MainWindow

% Last Modified by GUIDE v2.5 31-May-2013 11:41:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MainWindow_OpeningFcn, ...
                   'gui_OutputFcn',  @MainWindow_OutputFcn, ...
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


% --- Executes just before MainWindow is made visible.
function MainWindow_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MainWindow (see VARARGIN)

% Choose default command line output for MainWindow
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MainWindow wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MainWindow_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global vid
global Im2
%imaqreset;
vid=videoinput('winvideo',1,'YUY2_640x480');% take video input
triggerconfig(vid,'manual');  % after triggering only we get video
set(vid,'FramesPerTrigger',1); %only 1 frame per trigger
set(vid,'TriggerRepeat', Inf); %repeating trigger infinite timf
set(vid,'ReturnedColorSpace','rgb');% colour space used is rgb
start(vid);% video is started
faceDetector = vision.CascadeObjectDetector();
while(1)
    try
    trigger(vid);
    temp=getdata(vid,1);% take video data
    axes(handles.axes1); %point to the axes where u want to display the frame
    imshow(temp);  %show the frame on axes
    g=getsnapshot(vid);
    %% Detect face
    %{
     data = g;
 diff_im = imsubtract(data(:,:,1), rgb2gray(data));
 diff_im = medfilt2(diff_im, [3 3]);
 diff_im = imadjust(diff_im);
 level = graythresh(diff_im);
 bw = im2bw(diff_im,level);
 BW5 = imfill(bw,'holes');
 bw6 = bwlabel(BW5, 8);
 stats = regionprops(bw6,['basic']);%basic mohem nist
 [N,M]=size(stats);
 if (bw==0)
         break;
 else
 
      tmp = stats(1);
 for i = 2 : N
       if stats(i).Area > tmp.Area
         tmp = stats(i);
       end
    
 end
 end
 bb = tmp.BoundingBox;
    %}
    
    
% bc = tmp.Centroid;
% subplot(4,2,1);
% % hold on
% %  axes(handles.axes1);
% % rectangle('Position',bb,'EdgeColor','r','LineWidth',2)
% % hold off
data=g;
videoFrame=data;
  bb = step(faceDetector, videoFrame);
 [Im1,Im2]=Separate(data,bb);
 axes(handles.axes2);
 imshow(Im2);
    pause(.2);
    catch
        break;
    end
end

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global vid;
global Im2;
try
stop(vid);
end
%% Extract Face Rectangle

faceI=Im2;
axes(handles.axes3);
imshow(faceI);


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Im2;
global className;
try
    load dbs;
    feature=lbp_sir(rgb2gray(Im2));
    dbs=[dbs; feature];
    f=find(classes==className);
    f=length(f);
    f=f+1;
    fname=strcat( num2str(className),'_',num2str(f),'.png');
    imwrite(Im2,fname,'png');
    classes=[classes ;className];
    save dbs dbs classes;
    
catch
    dbs=[];
    classes=[];
    feature=lbp_sir(rgb2gray(Im2));
    dbs=[dbs; feature];
    classes=[classes ;className];
     fname=strcat( num2str(className),'_',num2str(1),'.png');
    imwrite(Im2,fname,'png');
    save dbs dbs classes;
end
axes(handles.axes3);
plot(feature);
msgbox('Training done');


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
global className
className=str2double(get(hObject,'String'));


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load dbs
figure;
db=dir('*.png');
n= ceil(sqrt(length(db)));
for(i=1:length(db))
    im=imread(db(i).name);
    subplot(n,n,i);
    imshow(im);
    title(num2str(classes(i)));
end


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global vid;
global Im2;
stop(vid);
%% Extract Face Rectangle
faceI=Im2;
axes(handles.axes3);
imshow(faceI);
%% Recognize

load dbs
db=dir('*.png');
n= ceil(sqrt(length(db)));
F=[];
for(i=1:length(db))
    im=imread(db(i).name);
   im=imresize(im,[128 128]);
    f=lbp_sir(rgb2gray(im));
    F=[F;f];
    title(num2str(classes(i)));
end
size(Im2)
Im2=imresize(Im2,[128 128]);
ftest=lbp_sir(rgb2gray(Im2));
for(i=1:length(db))
D(i,:)=abs(F(i,:)-ftest);
end
score=Inf;
match=-1;
for(i=1:length(db))
    s=sum(D(i,:));
    if(s<score)
        match=i;
        score=s;
    end
end
match
detected=classes(match)
fname=db(match).name;
axes(handles.axes3);
imshow(imread(fname));
title(strcat('detected class is:',num2str(detected)));


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Im2;
faceDetector = vision.CascadeObjectDetector();
[fname path]=uigetfile('*.jpg');
fname=strcat(path,fname);
im=imread(fname);
axes(handles.axes1);
imshow(im);
 bb = step(faceDetector, im);
 [Im1,Im2]=Separate(im,bb);
 axes(handles.axes2);
 imshow(Im2);
