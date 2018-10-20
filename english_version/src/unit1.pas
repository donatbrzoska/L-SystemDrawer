unit Unit1;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Spin;

type
  { TForm1 }
  TForm1 = class(TForm)
    Button1: TButton;
Button2: TButton;Button3: TButton;Button4: TButton;Button5: TButton;Button6: TButton;
    Button7: TButton;Button8: TButton;
    CheckBox1: TCheckBox;
    ComboBox1: TComboBox;
    Edit1: TEdit;Edit10: TEdit;Edit11: TEdit;
    Edit12: TEdit;
Edit2: TEdit;Edit26: TEdit;Edit3: TEdit;Edit4: TEdit;
    Edit5: TEdit;Edit6: TEdit;Edit7: TEdit;Edit8: TEdit;Edit9: TEdit;
    FloatSpinEdit1: TFloatSpinEdit;
    Label1: TLabel;Label10: TLabel;Label11: TLabel;Label12: TLabel;Label2: TLabel;
    Label26: TLabel;Label3: TLabel;Label4: TLabel;Label5: TLabel;Label6: TLabel;Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Panel1: TPanel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;
  sx,sy: Integer;
  tx,ty,sd,direction,alpha: Real;

implementation
{$R *.lfm}
{ TForm1 }

//forward
procedure forwd(steplength:Real);
const pi=3.14159265359;
var dx,dy,txtemp,tytemp:Real;
begin
  txtemp:=tx;                           //save x1
  tytemp:=ty;                           //save y1
  dx:=steplength*cos(direction*pi/180); //calculate delta x
  dy:=steplength*sin(direction*pi/180); //calculate delta y
  tx:=tx+dx;                            //determine x2
  ty:=ty-dy;                            //determine y2
  Form1.Panel1.canvas.pen.width:=StrToInt(Form1.Edit26.Text);
  Form1.Panel1.canvas.line(round(txtemp),round(tytemp),
                                  round(tx),round(ty));
end;

//turn by angle alpha
procedure turn(alpha:real);
begin
  direction:=direction+alpha;
end;

//set turtle to given position and direction
procedure resetturtle(sx,sy,sd:real);
begin
  tx:=sx;
  ty:=sy;
  direction:=sd;
end;

//power function for calculating shrinking factors
function pot(a:real;n:integer):real;
begin
     if n=0 then pot:=1
       else begin
         if n=1 then pot:=a
           else pot:=a*pot(a, n-1);
       end;
end;

//application of the production rules on a given string
function iterateT(system:string):string;
var
    i: integer; res: string;
begin
    res:='';
    for i:=1 to length(system) do
      case system[i] of
         'F':res:=res+Form1.Edit4.Text;
         'X':res:=res+Form1.Edit8.Text;
         'Y':res:=res+Form1.Edit9.Text;
         'Z':res:=res+Form1.Edit11.Text;
         '-':res:=res+'-';
         '+':res:=res+'+';
         '[':res:=res+'[';
         ']':res:=res+']';
      end;
    iterateT:=res;
end;

//applies production rules on a given system for n ("times") iterations
function iterate(system:string;times:integer):string;
var
    i:integer;
begin
  if times=0 then iterate:=system
     else
       begin
         iterate:=system;
         for i:=1 to times do
             iterate:=iterateT(iterate);
       end;
end;


//draws entered L-System
procedure draw(input:string);
var
  i,iterations,memorypos:integer;
  LSystem:string;
  step:real;
  turtlememory: array [1..100000,1..3] of real;  //Stack for coordinates and direction
begin
  Form1.Panel1.Repaint;
  resetturtle(StrToFloat(Form1.Edit1.Text),StrToFloat(Form1.Edit2.Text),
                                                 StrToFLoat(Form1.Edit3.Text));
  alpha:=StrToFloat(Form1.Edit6.Text);
  memorypos:=0;
  iterations:=StrToInt(Form1.Edit5.Text);
  LSystem:=iterate(input, iterations);

  Form1.Edit10.Text:=LSystem;
  if Form1.checkbox1.checked=true then step:=(Form1.FloatSpinEdit1.Value)
    else step:=882 * pot(StrToFloat(Form1.Edit12.Text), iterations);
  for i:=1 to length(LSystem) do
      case LSystem[i] of
        'F': forwd(step);
        '-': turn(alpha);
        '+': turn(-alpha);
        '[': begin    //saves position and direction
               memorypos:=memorypos+1;
               turtlememory[memorypos,1]:= tx;
               turtlememory[memorypos,2]:= ty;
               turtlememory[memorypos,3]:= direction;
             end;
        ']': begin    //restores last saves position and direction
               tx:= turtlememory[memorypos,1];
               ty:= turtlememory[memorypos,2];
               direction:= turtlememory[memorypos,3];
               memorypos:=memorypos-1;
             end;
      end;
end;

//Reset
procedure TForm1.Button1Click(Sender: TObject);
begin
  Panel1.Repaint;
  Edit7.Text:='';
  Edit4.Text:='';
  Edit8.Text:='';
  Edit9.Text:='';
  Edit11.Text:='';
  Edit6.Text:='0';
  Checkbox1.checked:=false;
  Edit5.Text:='1';
  Edit1.Text:='441';
  Edit2.Text:='705';
  Edit3.Text:='90';
  Edit26.Text:='1';
end;

//draw L-System
procedure TForm1.Button3Click(Sender: TObject);
begin
  draw(Edit7.Text);
end;

//increment iteration level
procedure TForm1.Button2Click(Sender: TObject);
begin
  Edit5.Text:=IntToStr(StrToInt(Edit5.Text)+1);
  draw(Edit7.Text);
end;

//decrement iteration level
procedure TForm1.Button4Click(Sender: TObject);
begin
  if StrToInt(Edit5.Text)=0 then Edit5.Text:=IntToStr(0)
     else Edit5.Text:=IntToStr(StrToInt(Edit5.Text)-1);
  draw(Edit7.Text);
end;

//decrement start x of turtle
procedure TForm1.Button5Click(Sender: TObject);
begin
  Edit1.Text:=IntToStr(StrToInt(Edit1.Text)-20);
  draw(Edit7.Text);
end;

//increment start x of turtle
procedure TForm1.Button6Click(Sender: TObject);
begin
  Edit1.Text:=IntToStr(StrToInt(Edit1.Text)+20);
  draw(Edit7.Text);
end;

//decrement start y of turtle
procedure TForm1.Button7Click(Sender: TObject);
begin
  Edit2.Text:=IntToStr(StrToInt(Edit2.Text)-20);
  draw(Edit7.Text);
end;

//increment start y of turtle
procedure TForm1.Button8Click(Sender: TObject);
begin
  Edit2.Text:=IntToStr(StrToInt(Edit2.Text)+20);
  draw(Edit7.Text);
end;


procedure TForm1.ComboBox1Change(Sender: TObject);
begin
  case ComboBox1.Text of
    'Manual':begin
           Edit7.Text:='';
           Edit4.Text:='';
           Edit8.Text:='';
           Edit9.Text:='';
           Edit11.Text:='';
           Edit6.Text:='0';
           Checkbox1.checked:=false;
           Edit5.Text:='1';
           Edit1.Text:='441';
           Edit2.Text:='705';
           Edit3.Text:='90';
           Edit26.Text:='1';
    end;
    'Wild Carrot': begin
           Edit7.Text:='X';
           Edit4.Text:='FF';
           Edit8.Text:='F-[-----------Y][+++++++++++Z]FX';
           Edit9.Text:='F++[----------Y][++++++++++Z]FY';
           Edit11.Text:='F--[++++++++++Z][----------Y]FZ';
           Edit6.Text:='6,8';
           Checkbox1.checked:=true;
           Floatspinedit1.Value:=0.33;
           Edit5.Text:='10';
           Edit1.Text:='441';
           Edit2.Text:='705';
           Edit3.Text:='90';
           Edit26.Text:='1';
    end;
    'Yarrow': begin            
           Edit9.Text:='';
           Edit11.Text:='';
           Edit7.Text:='X';
           Edit4.Text:='FF';
           Edit8.Text:='[+++++FFFFFFFFFF-FFFFFFFFFF-X][FFFFFFFFFFFFFFFFFFFX][FFFF-----FFFFFFFF+FFFFFFFF+X]';
           Edit6.Text:='6';
           Checkbox1.checked:=true;
           Floatspinedit1.Value:=0.13;
           Edit5.Text:='8';
           Edit1.Text:='421';
           Edit2.Text:='705';
           Edit3.Text:='90';
           Edit26.Text:='1';
    end;
    'Leaf like': begin       
           Edit9.Text:='';
           Edit11.Text:='';
           Edit7.Text:='X';
           Edit4.Text:='FF';
           Edit8.Text:='[------FX][+FFFX]+[+++++FFX]';
           Edit6.Text:='8';
           Checkbox1.checked:=true;
           Floatspinedit1.Value:=0.46;
           Edit5.Text:='9';
           Edit1.Text:='361';
           Edit2.Text:='685';
           Edit3.Text:='90';
           Edit26.Text:='1';
    end;
    'Weed 1': begin      
           Edit9.Text:='';
           Edit11.Text:='';
           Edit7.Text:='F[++X]FF[---X]FFX';
           Edit4.Text:='FF';
           Edit8.Text:='F[++X]FF[---X]FFX';
           Edit6.Text:='10';
           Checkbox1.checked:=true;
           Floatspinedit1.Value:=0.13;
           Edit5.Text:='9';
           Edit1.Text:='420';
           Edit2.Text:='700';
           Edit3.Text:='90';
           Edit26.Text:='1';
    end;
    'Weed 2': begin    
           Edit9.Text:='';
           Edit11.Text:='';
           Edit7.Text:='F[++X]FF[---X]FFX';
           Edit4.Text:='FF';
           Edit8.Text:='FF[++FFX]FF[--X]FFX';
           Edit6.Text:='10';
           Checkbox1.checked:=true;
           Floatspinedit1.Value:=0.24;
           Edit5.Text:='8';
           Edit1.Text:='420';
           Edit2.Text:='700';
           Edit3.Text:='90';
           Edit26.Text:='1';
    end;
    'Weed 3': begin         
           Edit9.Text:='';
           Edit11.Text:='';
           Edit7.Text:='X';
           Edit4.Text:='FF';
           Edit8.Text:='F[--FX]F[++FX]F[--F+FX]FF';
           Edit6.Text:='8';
           Checkbox1.checked:=true;
           Floatspinedit1.Value:=0.28;
           Edit5.Text:='9';
           Edit1.Text:='441';
           Edit2.Text:='705';
           Edit3.Text:='90';
           Edit26.Text:='1';
    end;
    'Tree 1': begin          
           Edit9.Text:='';
           Edit11.Text:='';
           Edit7.Text:='X';
           Edit4.Text:='FF';
           Edit8.Text:='F[++F-X][--F[++X][--X]]';
           Edit6.Text:='15';
           Checkbox1.checked:=true;
           Floatspinedit1.Value:=0.7;
           Edit5.Text:='9';
           Edit1.Text:='501';
           Edit2.Text:='705';
           Edit3.Text:='90';
           Edit26.Text:='1';
    end;
    'Tree 2': begin      
           Edit9.Text:='';
           Edit11.Text:='';
           Edit7.Text:='X';
           Edit4.Text:='FF';
           Edit8.Text:='[-FX]F[+FX]F[-FX]FF[-X][+X]';
           Edit6.Text:='20';
           Checkbox1.checked:=true;
           Floatspinedit1.Value:=1.2;
           Edit5.Text:='7';
           Edit1.Text:='441';
           Edit2.Text:='705';
           Edit3.Text:='90';
           Edit26.Text:='1';
    end;
    'Dragen Curve': begin
           Edit11.Text:='';
           Edit7.Text:='FX';
           Edit4.Text:='F';
           Edit8.Text:='-FX-Y';
           Edit9.Text:='X+YF+';
           Edit6.Text:='90';
           Checkbox1.checked:=true;
           Floatspinedit1.Value:=2;
           Edit5.Text:='18';
           Edit1.Text:='400';
           Edit2.Text:='200';
           Edit3.Text:='90';
           Edit26.Text:='1';
    end;
    'Sierpinski Triangle': begin     
           Edit9.Text:='';
           Edit11.Text:='';
           Edit7.Text:='FXF++FF++FF';
           Edit4.Text:='FF';
           Edit8.Text:='++FXF - - FXF - - FXF++';
           Edit6.Text:='60';
           Checkbox1.checked:=true;
           Floatspinedit1.Value:=0.75;
           Edit5.Text:='9';
           Edit1.Text:='60';
           Edit2.Text:='700';
           Edit3.Text:='60';
           Edit26.Text:='1';
    end;
    'Koch Curve': begin      
           Edit9.Text:='';
           Edit11.Text:='';
           Edit7.Text:='F';
           Edit4.Text:='F-F++F-F';
           Edit8.Text:='';
           Edit6.Text:='60';
           Checkbox1.checked:=false;
           Edit5.Text:='6';
           Edit1.Text:='0';
           Edit2.Text:='700';
           Edit3.Text:='0';
           Edit26.Text:='1';
    end;
  end;
end;


end.

