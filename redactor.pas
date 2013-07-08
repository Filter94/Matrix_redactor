program redactor;

uses table,crt;

type
poimatrix=^matrix;
Matarr= array [1..1] of poimatrix;
Matrixes=record
Mat:^Matarr;
Max:byte;
end;

const
screenway='screen.txt';
menmax=6;
menushka:array [1..menmax] of string=('�롥�� ����� ����','������� ����� ⠡����','������� ⠡����','�����஢��� �� ����� ⥪���� ⠡����','������஢��� ⠡����','...� ��।㬠�(�)');



var 
goodbye,goodbyechik:boolean;
Matxs:Matrixes;
CurrentMatrix,screenH,screenW,k,l:byte;
screen: text;

procedure menu;forward;
procedure gotomenu(j,d:byte);forward;

procedure shownotall(a:matrix;fromb,tob,fromc,toc,k,l:integer);//b-��ப�, c-�⮫���.
var
i,j,q:integer;
begin
	for j:=fromb to tob do
		for i:=fromc to toc do
			if i<toc then
				begin
					if (a.showme(i,j)>=exp((k-1-l)*ln(10)))or(a.showme(i,j)<=trunc(-exp((k-2-l)*ln(10)))) then
						begin
						write('����讥');
						for q:=1 to k+1-7 do
							write(' ')
						end
					else
					write(a.showme(i,j):k:l,' ')
				end
			else
				if (a.showme(i,j)>=exp((k-1-l)*ln(10)))or(a.showme(i,j)<=trunc(-exp((k-2-l)*ln(10)))) then
						writeln('����讥')
					else
					writeln(a.showme(i,j):k:l,' ')
end;

function Gibtes(const Filyway:string):boolean;//������� �� 䠩�
var
Fily:file;
begin
assign(fily,filyway);
{$I-}
reset(fily);
{$I+}
if ioresult<>0 then
gibtes:=false
else
gibtes:=true;
{$I-}
close(fily);
{$I+}
end;

function request(S:string):boolean;//����� ���⢥ত���� ����� S
var
a:char;
begin
request:=false;
TextBackGround(1);
clrscr;
writeln(S+'? Y/N');
repeat
a:=readkey
until a in ['y','n','Y','�','�','�'];
if a in ['y','Y','�','�'] then
	request:=true
else
request:=false;
end;

function redind(const i:byte):byte;//�ᯮ����⥫쭠� �㭪�� ��� ���᫥��� ��ࢮ� ���न���� ��� gotoxy �� ������ i � ।����
begin
redind:=(k+1)*(i)-k
end;

procedure hortmacht(var now,next:byte;const outw,outa,row:integer);//�㭪�� ���㦨����� ��।������� �� ��ਧ��⠫� � ।����
var
i,q:byte;
begin
	i:=redind(next);
	gotoxy(redind(now),row);
	TextBackGround(1);
	if (Matxs.mat^[CurrentMatrix]^.showme(now+outa-1,row+outw-1)>=exp((k-1-l)*ln(10)))or(Matxs.mat^[CurrentMatrix]^.showme(now+outa-1,row+outw-1)<=trunc(-exp((k-2-l)*ln(10)))) then
		begin
			write('����讥');
			for q:=1 to k+1-7 do
				write(' ')
		end
	else
	write(Matxs.mat^[CurrentMatrix]^.showme(now+outa-1,row+outw-1):k:l);
	TextBackGround(5);
	gotoxy(i,row);
	if (Matxs.mat^[CurrentMatrix]^.showme(next+outa-1,row+outw-1)>=exp((k-1-l)*ln(10)))or(Matxs.mat^[CurrentMatrix]^.showme(next+outa-1,row+outw-1)<=trunc(-exp((k-2-l)*ln(10)))) then
		begin
			write('����讥');
			for q:=1 to k+1-7 do
				write(' ')
		end
	else
	write(Matxs.mat^[CurrentMatrix]^.showme(next+outa-1,row+outw-1):k:l);
	now:=next;
	gotoxy(17,screenH-1);
	TextBackGround(1);
	writeln(Matxs.mat^[CurrentMatrix]^.showme(next+outa-1,row+outw-1));
	gotoxy(22,screenH);
	writeln(next+outa-1:3,' ',row+outw-1:3);
	TextBackGround(1);
end;

procedure vermacht(var zieg,heil:byte;const outw,outa,fuhrer:integer);//�㭪�� ���㦨����� ��।������� �� ���⨪��� � ।����
var
i,q:byte;
begin
	i:=redind(fuhrer);
	gotoxy(i,zieg);
	TextBackGround(1);
	if (Matxs.mat^[CurrentMatrix]^.showme(fuhrer+outa-1,zieg+outw-1)>=exp((k-1-l)*ln(10)))or(Matxs.mat^[CurrentMatrix]^.showme(fuhrer+outa-1,zieg+outw-1)<=trunc(-exp((k-2-l)*ln(10)))) then
		begin
			write('����讥');
			for q:=1 to k+1-7 do
				write(' ')
		end
	else
	write(Matxs.mat^[CurrentMatrix]^.showme(fuhrer+outa-1,zieg+outw-1):k:l);
	TextBackGround(5);
	gotoxy(i,heil);
	if (Matxs.mat^[CurrentMatrix]^.showme(fuhrer+outa-1,heil+outw-1)>=exp((k-1-l)*ln(10)))or(Matxs.mat^[CurrentMatrix]^.showme(fuhrer+outa-1,heil+outw-1)<=trunc(-exp((k-2-l)*ln(10)))) then
		begin
			write('����讥');
			for q:=1 to k+1-7 do
				write(' ')
		end
	else
	write(Matxs.mat^[CurrentMatrix]^.showme(fuhrer+outa-1,heil+outw-1):k:l);
	zieg:=heil;
	gotoxy(17,screenH-1);
	TextBackGround(1);
	writeln(Matxs.mat^[CurrentMatrix]^.showme(fuhrer+outa-1,heil+outw-1));
	gotoxy(22,screenH);
	writeln(fuhrer+outa-1:3,' ',heil+outw-1:3);
	TextBackGround(1);
end;

function minof(const a,b:integer):integer;//�������쭮� �� a,b
begin
if a<b then
	minof:=a
	else
		minof:=b
end;

procedure redaction;//�������
var
	i,j,next,tick,outa,outw,outs,outd:byte;
	key:char;
	c:single;
	n,m:integer;
begin
TextBackGround(1);
clrscr;
begin
	if currentmatrix<>0 then
	begin
		i:=1;//���樠������ �ᥣ�
		j:=1;
		outw:=1;
		outs:=minof(screenH-2,Matxs.mat^[CurrentMatrix]^.howmanyrows);
		outa:=1;
		outd:=minof(screenW,Matxs.mat^[CurrentMatrix]^.howmanycols);
		shownotall(Matxs.mat^[CurrentMatrix]^,outw,outs,outa,outd,k,l);
		gotoxy(1,screenH-1);
		writeln('����騩 ����� ',Matxs.mat^[CurrentMatrix]^.showme(i,j),'  Backspase-������.');
		gotoxy(1,screenH);
		writeln('����� � ',CurrentMatrix);
		gotoxy(13,screenH);
		writeln('�������: ',i:3,' ',j:3)
	end
	else
		writeln('������ R ��� �⥭�� ������ �� 䠩�� ��� Esc ��� ��室�.');
	while goodbyechik=false do
	begin
		TextBackGround(1);
		gotoxy(redind(i),j);//���室�� �� ⥪�騩 ����� � �⠥� ������
		if currentmatrix<>0 then
			repeat
				key:=readkey;
			until key in [#27,#72,#80,#13,#75,#77,#9,#8,'w','s','a','d','W','S','A','D','�','�','�','�','�','�','�','�','r','f','R','F','�','�','�','�']
		else
			repeat
				key:=readkey;
			until key in [#27,'r','R','�','�'];
		case key of
		#72:if j>1 then//�����
				begin
					next:=j-1;
					vermacht(j,next,outw,outa,i);
				end
			else
				begin
					next:=minof(screenH-2,Matxs.mat^[CurrentMatrix]^.howmanyrows);
					vermacht(j,next,outw,outa,i);
				end;
		#80:if j<minof(screenH-2,Matxs.mat^[CurrentMatrix]^.howmanyrows) then//����
				begin
					next:=j+1;
					vermacht(j,next,outw,outa,i);
				end
				else
				begin
					next:=1;
					vermacht(j,next,outw,outa,i);
				end;
		#27:begin//Escape
				goodbyechik := true;
				TextBackGround(1);
				clrscr;
				writeln('��室 � ����.');
			end;
		#13:begin//Enter
				gotoxy(redind(i),j);
				for tick:=1 to k do
					Write(' ');
				gotoxy(redind(i),j);
				TextBackGround(14);
					{$I-}
				read(c);
					{$i+}
				if ioresult<>0 then
					begin
						gotoxy(16,screenH-1);
						TextBackGround(1);
						write(' ');
						TextBackGround(14);
						write('����୮� �᫮');
						TextBackGround(1);
						write('  ');
						gotoxy(1,1);
						shownotall(Matxs.mat^[CurrentMatrix]^,outw,outs,outa,outd,k,l);
						gotoxy(i,j);
					end
				else
				begin
					Matxs.mat^[CurrentMatrix]^.wochanges(i+outa-1,j+outw-1,c);
					gotoxy(1,j);
					TextBackGround(1);
					shownotall(Matxs.mat^[CurrentMatrix]^,outw+j-1,outw+j-1,outa,outd,k,l);
					hortmacht(i,i,outw,outa,j)
				end;
			end;
		#75:if i>1 then//�����
				begin
					next:=i-1;
					hortmacht(i,next,outw,outa,j);
				end
			else
				begin
					next:=minof(screenW,Matxs.mat^[CurrentMatrix]^.howmanycols);
					hortmacht(i,next,outw,outa,j);
				end;
		#77:if i<minof(screenW,Matxs.mat^[CurrentMatrix]^.howmanycols) then//��ࠢ�
				begin
					next:=i+1;
					hortmacht(i,next,outw,outa,j);
				end
			else
			begin
				next:=1;
				hortmacht(i,next,outw,outa,j);
			end;
		'w','W','�','�':if outw>1 then//��।������� �� �����
							begin
								gotoxy(1,1);
								outw:=outw-1;
								outs:=outs-1;
								shownotall(Matxs.mat^[CurrentMatrix]^,outw,outs,outa,outd,k,l);
								hortmacht(i,i,outw,outa,j);
							end;
		's','S','�','�':if outw<=Matxs.mat^[CurrentMatrix]^.howmanyrows-(screenH-2) then
							begin
								gotoxy(1,1);
								outw:=outw+1;
								outs:=outs+1;
								shownotall(Matxs.mat^[CurrentMatrix]^,outw,outs,outa,outd,k,l);
								hortmacht(i,i,outw,outa,j);
							end;
		'a','A','�','�':if outa>1 then
							begin
								gotoxy(1,1);
								outa:=outa-1;
								outd:=outd-1;
								shownotall(Matxs.mat^[CurrentMatrix]^,outw,outs,outa,outd,k,l);
								hortmacht(i,j,outw,outa,j);
							end;
		'd','�','D','�':if outa<=Matxs.mat^[CurrentMatrix]^.howmanycols-screenW then
							begin
								gotoxy(1,1);
								outa:=outa+1;
								outd:=outd+1;
								shownotall(Matxs.mat^[CurrentMatrix]^,outw,outs,outa,outd,k,l);
								hortmacht(i,i,outw,outa,j);
							end;
		#8:begin//Backspase, ������
				TextBackGround(1);
				clrscr;
				gotoxy(1,1);
				writeln('��६�饭�� �� �����-w,s,a,d , �롮� �����-��५����. R- ����� ������ �� 䠩��, F- ���࠭��� ������ � 䠩�. ��஫���� - tab');
				readln;
				redaction
			end;
		'r','R','�','�':begin//�⥭��
							gotomenu(7,CurrentMatrix);
							if CurrentMatrix<>0 then
							begin
								outa:=1;
								outw:=1;
								outs:=minof(screenH-2,Matxs.mat^[CurrentMatrix]^.howmanyrows);
								outd:=minof(screenW,Matxs.mat^[CurrentMatrix]^.howmanycols);
								i:=1;
								j:=1;
								gotoxy(1,1);
								shownotall(Matxs.mat^[CurrentMatrix]^,outw,outs,outa,outd,k,l);
								gotoxy(1,screenH-1);
								writeln('����騩 ����� ',Matxs.mat^[CurrentMatrix]^.showme(i,j),'  Backspase-������.');
								gotoxy(1,screenH);
								writeln('����� � ',CurrentMatrix);
								gotoxy(13,screenH);
								writeln('�������: ',i:3,' ',j:3)
							end
							else
								writeln('������ R ��� �⥭�� ������ �� 䠩�� ��� Esc ��� ��室�.');
						end;
		'�','�','F','f':begin//���࠭����
							gotomenu(8,CurrentMatrix);
							TextBackGround(1);
							clrscr;
							shownotall(Matxs.mat^[CurrentMatrix]^,outw,outs,outa,outd,k,l);
							gotoxy(1,screenH-1);
							writeln('����騩 ����� ',Matxs.mat^[CurrentMatrix]^.showme(i,j),'  Backspase-������.');
							gotoxy(1,screenH);
							writeln('����� � ',CurrentMatrix);
							gotoxy(13,screenH);
							writeln('�������: ',i:3,' ',j:3)
						end;
					#9:begin//Tab
							
						end;
			end
		end
	end
end;

procedure creation;//�������� ������
var
	i,j:integer;
begin
	TextBackGround(1);
	clrscr;
	writeln('������ ���-�� �⮫�殢, ��ப.');
	repeat
			{$I-}
		readln(i,j);
			{$I+}
	until ioresult=0;
	inc(Matxs.max);
	CurrentMatrix:=Matxs.max;
	getmem(Matxs.mat^[CurrentMatrix],sizeof(matrix));
	Matxs.mat^[CurrentMatrix]^.create(i,j);
	if request('��������� ⠡���� ��砩�묨 �᫠��') then
		begin
			randomize;
			for i:=1 to Matxs.mat^[CurrentMatrix]^.howmanycols do
				for j:=1 to Matxs.mat^[CurrentMatrix]^.howmanyrows do
					Matxs.mat^[CurrentMatrix]^.wochanges(i,j,random*100-50)
		end
end;

procedure Deletion;//�������� ������ CurrentMatrix
var
i:byte;
s:string;
begin
	TextBackGround(1);
	clrscr;
if CurrentMatrix<>0 then
	begin
	str(CurrentMatrix,s);
	if request('�� ����⢨⥫쭮 ��� 㤠���� ������ '+s) then
		begin
			Matxs.mat^[CurrentMatrix]^.destroy;
			For i:=CurrentMatrix to Matxs.max do
				Matxs.mat^[i]:=Matxs.mat^[i+1];
			dec(matxs.max);
			TextBackGround(1);
			clrscr;
			writeln('�������� ��諮 �ᯥ譮.');
			readln;
			CurrentMatrix:=0
		end
	end
	else
	begin
		writeln('����� �� ��࠭�.');
		readln
	end
end;

procedure shellsort;//����஢�� �����
var
s:string;
begin
	str(CurrentMatrix,s);
		TextBackGround(1);
		clrscr;
	if (CurrentMatrix<>0)and(request('�� ����⢨⥫쭮 ��� �����஢��� ������ '+s)) then
	begin
		writeln(Matxs.mat^[CurrentMatrix]^.showmekeys(k,l));
		Matxs.mat^[CurrentMatrix]^.shellsort;
		Writeln(Matxs.mat^[CurrentMatrix]^.showmekeys(k,l));
		writeln('����஢�� �����祭�!');
			readln;
	end
		else
		if CurrentMatrix =0 then
			writeln('����� �� ��࠭�.');
end;

procedure reading;//�⥭�� ������ �� 䠩��
var
i,j:integer;
d,f:single;
fily:file of single;
filyway:string;
begin
	TextBackGround(1);
	clrscr;
	writeln('������ ��� 䠩��, �� ���ண� ��� ����� ������.');
	repeat
				{$I-}
		readln(filyway);
				{$I+}
	until (ioresult=0)and(filyway<>'');
	if gibtes(filyway) then
		begin
			inc(Matxs.max);
			CurrentMatrix:=Matxs.max;
			getmem(Matxs.mat^[Matxs.max],sizeof(matrix));
			assign(fily,filyway);
				{$I-}
			reset(fily);
				{$I+}
			if ioresult=0 then
				begin
					read(fily,d);
					read(fily,f);
					i:=trunc(d);
					j:=trunc(f);
					Matxs.mat^[Matxs.max]^.create(i,j);
					for i:=1 to Matxs.mat^[CurrentMatrix]^.howmanycols do
						for j:=1 to Matxs.mat^[CurrentMatrix]^.howmanyrows do
							begin
								read(fily,d);
								Matxs.mat^[CurrentMatrix]^.wochanges(i,j,d);
							end;
					clrscr;
					writeln('����� �ᯥ譮 ��⠭� � 䠩�� ', filyway);
						{$I-}
					close(fily)
						{$I+}
				end
			else
				writeln('�����४⭮� ��� 䠩��.');
		end
	else
		WRITELN('���� �� �������');
		readln
end;

procedure salvation;//���࠭���� ������ � 䠩�
var
i,j:integer;
fily:file of single;
filyway:string;
begin
	TextBackGround(1);
	clrscr;
	if CurrentMatrix<>0 then
		begin
			writeln('������ ��� 䠩��, � ����� �㤥� ����ᠭ� �����.');
			repeat
				{$I-}
			readln(filyway);
				{$I+}
			until (ioresult=0)and(filyway<>'');
			assign(fily,filyway);
			{$I-}
			rewrite(fily);
			{$I+}
			if ioresult=0 then
			begin
				write(fily,Matxs.mat^[CurrentMatrix]^.howmanycols,Matxs.mat^[CurrentMatrix]^.howmanyrows);
				for i:=1 to Matxs.mat^[CurrentMatrix]^.howmanycols do
					for j:=1 to Matxs.mat^[CurrentMatrix]^.howmanyrows do
						begin
							write(fily,Matxs.mat^[CurrentMatrix]^.showme(i,j));
						end;
				clrscr;
				writeln('����� �ᯥ譮 ��࠭��� � 䠩�� ', filyway);
					{$I-}
				close(fily)
					{$I+}
			end
			else
			writeln('�����४⭮� ��� 䠩��.');
		end
	else
		writeln('����� �� ��࠭�.');
	readln;
end;

procedure gotomenu(j,d:byte);//�㭪�� ���㦨����� ������� Enter � ����, ���室�� � ���� ��� ����஬ j, CurrentMatrix ��ᢠ����� d
begin
	CurrentMatrix:=d;
	case j of 
		2:creation;
		3:Deletion;
		4:shellsort;
		7:reading;
		5:begin
			goodbyechik:= false;
			redaction;
		end;
		8:salvation;//Saving
		6:if request('�� ����⢨⥫쭮 ��� ���') then
			goodbye:=true
	end;
end;

function menind(i:byte):byte;//�ᯮ����⥫쭠� �㭪�� ��� ���᫥��� ��ࢮ� ���न���� ��� gotoxy �� ������ i � ����
begin
menind:=7+i*3
end;

procedure vertmenu(var now,next:byte);//�㭪�� ���㦨����� ��।������� �� ���⨪��� � ����
begin
gotoxy(1,now);
TextBackGround(1);
write(menushka[now]);
TextBackGround(5);
gotoxy(1,next);
write(menushka[next]);
now:=next;
end;

procedure hormenu(var now,next:byte);//�㭪�� ���㦨����� ��।������� �� ��ਧ��⠫� (�롮� ⥪�饩 ������) � ����
begin
	gotoxy(menind(now),9);
	TextBackGround(1);
	if now<>0 then
		write(now);
	TextBackGround(5);
	gotoxy(menind(next),9);
	write(next);
	now:=next;
end;

procedure menu;//����⢥���, ����
var
	nextv,nexth,i,j,d:byte;
    menus: char;
begin
	if not(goodbye=true)then
	begin
		i:=0;
		j:=2;
		TextBackGround(1);
		clrscr;
		TextColor(15);
		writeln('�롥�� ����� ����');
		writeln('������� ����� ⠡����');
		writeln('������� ⠡����');
		writeln('�����஢��� �� ����� ⥪���� ⠡����');
		writeln('������஢��� ⠡����');
		writeln('...� ��।㬠�(�)');
		gotoxy(1,screenH);
		writeln('Backspace-������.');
		gotoxy(1,screenH-1);
		write('�����: ');
		for d:=1 to Matxs.max do
			write(d,'  ');
		gotoxy(i,9);
		TextBackGround(5);
		gotoxy(1,j);
		TextBackGround(5);
		write(menushka[j]);
		if CurrentMatrix<>0 then
			hormenu(CurrentMatrix,CurrentMatrix);
		i:=CurrentMatrix;
		menus:=#1;
		while (goodbye = false)and(menus<>#13) do
			begin
				repeat
					menus:=readkey;
				until menus in [#27,#72,#80,#13,#75,#77,#8];
				case menus of
				#72:if j>2 then//�����
						begin
							nextv:=j-1;
							vertmenu(j,nextv);
						end
					else
						begin
							nextv:=menmax;
							vertmenu(j,nextv);
						end;
				#80:if j<menmax then//����
						begin
							nextv:=j+1;
							vertmenu(j,nextv);
						end
						else
						begin
							nextv:=2;
							vertmenu(j,nextv);
						end;
				#27:gotomenu(menmax,0);
				#13:gotomenu(j,i);
				#75:if  Matxs.max<>0 then//�����
							if i>1 then
								begin
									nexth:=i-1;
									hormenu(i,nexth);
								end
							else
								begin
									nexth:=Matxs.max;
									hormenu(i,nexth);
								end;
				#77:if Matxs.max<>0 then//��ࠢ�
							if i<Matxs.max then
								begin
									nexth:=i+1;
									hormenu(i,nexth);
								end
							else
								begin
									nexth:=1;
									hormenu(i,nexth);
								end;
				#8 :begin
						TextBackGround(1);
						clrscr;
						gotoxy(1,1);
						writeln('�롮� ������: ��ࠢ�, �����, ��६�饭�� �� ����: �����, ����.');
						writeln('���-�� �⮫�殢 � ।����: ',screenW,' �⮫�殢 ',screenH-2,' � ��ࠬ��ࠬ� �뢮�� ',k,' ',l,' (�ᥣ�, ��᫥ ����⮩.)');
						writeln('��ࠬ���� �࠭� �������� � screen.txt');
						readln;
						menu;
					end;
				end
			end
	end;
end;

begin
	CurrentMatrix:=0;//���樠������ �ᥣ�
	Matxs.mat:=Nil;
	Matxs.max:=0;
	getmem(Matxs.mat,sizeof(Matarr));
	CurrentMatrix:=Matxs.max;
	getmem(Matxs.mat^[CurrentMatrix],sizeof(matrix));
	Matxs.mat^[CurrentMatrix]^.create(1,1);
    goodbye := false;
	CurrentMatrix:=0;
	screenW:=0;
	screenH:=0;
	if gibtes(screenway) then//�⥭�� ���䨣-䠩��
		begin
			assign(screen,screenway);
			reset(screen);
				{$I-}
			read(screen,screenW,screenH,k,l);
				{$I+}
			if ioresult<>0 then
				begin
					screenW:=0;
					screenH:=0;
					k:=0;
					l:=0;
				end;
				{$I-}
			close(screen);
				{$I+}
		end;
	if	(l<3)or(l>15) then//��-���樠������ ��ࠬ��஢ �࠭� �� �����४⭮� �����
		l:=3;
	if (k<7)or(k>30) then
		k:=7;
	if not(k>2*l) then
		begin
			k:=7;
			l:=3;
		end;
	if screenH<10 then
		screenH:=10;
	if (screenW<5)or(screenW>50) then
		screenW:=5;
    repeat
        menu//�� ᫨誮� ����, ����⭮ � ����筮.
    until goodbye=true;
	clrscr;
	writeln('"����ࠫ쭮� �� �⨫� ��頭��"!');
	readln
end.