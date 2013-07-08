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
menushka:array [1..menmax] of string=('Выберете элемент меню','Создать новую таблицу','Удалить таблицу','Отсортировать по Шеллу текущую таблицу','Редактировать таблицу','...Я передумал(а)');



var 
goodbye,goodbyechik:boolean;
Matxs:Matrixes;
CurrentMatrix,screenH,screenW,k,l:byte;
screen: text;

procedure menu;forward;
procedure gotomenu(j,d:byte);forward;

procedure shownotall(a:matrix;fromb,tob,fromc,toc,k,l:integer);//b-Строка, c-столбец.
var
i,j,q:integer;
begin
	for j:=fromb to tob do
		for i:=fromc to toc do
			if i<toc then
				begin
					if (a.showme(i,j)>=exp((k-1-l)*ln(10)))or(a.showme(i,j)<=trunc(-exp((k-2-l)*ln(10)))) then
						begin
						write('Большое');
						for q:=1 to k+1-7 do
							write(' ')
						end
					else
					write(a.showme(i,j):k:l,' ')
				end
			else
				if (a.showme(i,j)>=exp((k-1-l)*ln(10)))or(a.showme(i,j)<=trunc(-exp((k-2-l)*ln(10)))) then
						writeln('Большое')
					else
					writeln(a.showme(i,j):k:l,' ')
end;

function Gibtes(const Filyway:string):boolean;//Существует ли файл
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

function request(S:string):boolean;//Запрос подтверждения вопроса S
var
a:char;
begin
request:=false;
TextBackGround(1);
clrscr;
writeln(S+'? Y/N');
repeat
a:=readkey
until a in ['y','n','Y','н','Н','т'];
if a in ['y','Y','н','Н'] then
	request:=true
else
request:=false;
end;

function redind(const i:byte):byte;//Вспомогательная функция для вычисления первой координаты для gotoxy от индекса i в редакторе
begin
redind:=(k+1)*(i)-k
end;

procedure hortmacht(var now,next:byte;const outw,outa,row:integer);//Функция обслуживающая передвижение по горизонтали в редакторе
var
i,q:byte;
begin
	i:=redind(next);
	gotoxy(redind(now),row);
	TextBackGround(1);
	if (Matxs.mat^[CurrentMatrix]^.showme(now+outa-1,row+outw-1)>=exp((k-1-l)*ln(10)))or(Matxs.mat^[CurrentMatrix]^.showme(now+outa-1,row+outw-1)<=trunc(-exp((k-2-l)*ln(10)))) then
		begin
			write('Большое');
			for q:=1 to k+1-7 do
				write(' ')
		end
	else
	write(Matxs.mat^[CurrentMatrix]^.showme(now+outa-1,row+outw-1):k:l);
	TextBackGround(5);
	gotoxy(i,row);
	if (Matxs.mat^[CurrentMatrix]^.showme(next+outa-1,row+outw-1)>=exp((k-1-l)*ln(10)))or(Matxs.mat^[CurrentMatrix]^.showme(next+outa-1,row+outw-1)<=trunc(-exp((k-2-l)*ln(10)))) then
		begin
			write('Большое');
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

procedure vermacht(var zieg,heil:byte;const outw,outa,fuhrer:integer);//Функция обслуживающая передвижение по вертикали в редакторе
var
i,q:byte;
begin
	i:=redind(fuhrer);
	gotoxy(i,zieg);
	TextBackGround(1);
	if (Matxs.mat^[CurrentMatrix]^.showme(fuhrer+outa-1,zieg+outw-1)>=exp((k-1-l)*ln(10)))or(Matxs.mat^[CurrentMatrix]^.showme(fuhrer+outa-1,zieg+outw-1)<=trunc(-exp((k-2-l)*ln(10)))) then
		begin
			write('Большое');
			for q:=1 to k+1-7 do
				write(' ')
		end
	else
	write(Matxs.mat^[CurrentMatrix]^.showme(fuhrer+outa-1,zieg+outw-1):k:l);
	TextBackGround(5);
	gotoxy(i,heil);
	if (Matxs.mat^[CurrentMatrix]^.showme(fuhrer+outa-1,heil+outw-1)>=exp((k-1-l)*ln(10)))or(Matxs.mat^[CurrentMatrix]^.showme(fuhrer+outa-1,heil+outw-1)<=trunc(-exp((k-2-l)*ln(10)))) then
		begin
			write('Большое');
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

function minof(const a,b:integer):integer;//Минимальное из a,b
begin
if a<b then
	minof:=a
	else
		minof:=b
end;

procedure redaction;//Редактор
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
		i:=1;//Инициализация всего
		j:=1;
		outw:=1;
		outs:=minof(screenH-2,Matxs.mat^[CurrentMatrix]^.howmanyrows);
		outa:=1;
		outd:=minof(screenW,Matxs.mat^[CurrentMatrix]^.howmanycols);
		shownotall(Matxs.mat^[CurrentMatrix]^,outw,outs,outa,outd,k,l);
		gotoxy(1,screenH-1);
		writeln('Текущий элемент ',Matxs.mat^[CurrentMatrix]^.showme(i,j),'  Backspase-помощь.');
		gotoxy(1,screenH);
		writeln('Матрица № ',CurrentMatrix);
		gotoxy(13,screenH);
		writeln('Индексы: ',i:3,' ',j:3)
	end
	else
		writeln('Нажиите R для чтения матрицы из файла или Esc для выхода.');
	while goodbyechik=false do
	begin
		TextBackGround(1);
		gotoxy(redind(i),j);//Переходим на текущий элемент и читаем клавиши
		if currentmatrix<>0 then
			repeat
				key:=readkey;
			until key in [#27,#72,#80,#13,#75,#77,#9,#8,'w','s','a','d','W','S','A','D','ц','ы','ф','в','Ц','Ы','Ф','В','r','f','R','F','а','к','А','К']
		else
			repeat
				key:=readkey;
			until key in [#27,'r','R','к','К'];
		case key of
		#72:if j>1 then//Вверх
				begin
					next:=j-1;
					vermacht(j,next,outw,outa,i);
				end
			else
				begin
					next:=minof(screenH-2,Matxs.mat^[CurrentMatrix]^.howmanyrows);
					vermacht(j,next,outw,outa,i);
				end;
		#80:if j<minof(screenH-2,Matxs.mat^[CurrentMatrix]^.howmanyrows) then//Вниз
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
				writeln('Выход в меню.');
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
						write('Неверное число');
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
		#75:if i>1 then//Влево
				begin
					next:=i-1;
					hortmacht(i,next,outw,outa,j);
				end
			else
				begin
					next:=minof(screenW,Matxs.mat^[CurrentMatrix]^.howmanycols);
					hortmacht(i,next,outw,outa,j);
				end;
		#77:if i<minof(screenW,Matxs.mat^[CurrentMatrix]^.howmanycols) then//Вправо
				begin
					next:=i+1;
					hortmacht(i,next,outw,outa,j);
				end
			else
			begin
				next:=1;
				hortmacht(i,next,outw,outa,j);
			end;
		'w','W','ц','Ц':if outw>1 then//Передвижение по матрице
							begin
								gotoxy(1,1);
								outw:=outw-1;
								outs:=outs-1;
								shownotall(Matxs.mat^[CurrentMatrix]^,outw,outs,outa,outd,k,l);
								hortmacht(i,i,outw,outa,j);
							end;
		's','S','ы','Ы':if outw<=Matxs.mat^[CurrentMatrix]^.howmanyrows-(screenH-2) then
							begin
								gotoxy(1,1);
								outw:=outw+1;
								outs:=outs+1;
								shownotall(Matxs.mat^[CurrentMatrix]^,outw,outs,outa,outd,k,l);
								hortmacht(i,i,outw,outa,j);
							end;
		'a','A','ф','Ф':if outa>1 then
							begin
								gotoxy(1,1);
								outa:=outa-1;
								outd:=outd-1;
								shownotall(Matxs.mat^[CurrentMatrix]^,outw,outs,outa,outd,k,l);
								hortmacht(i,j,outw,outa,j);
							end;
		'd','в','D','В':if outa<=Matxs.mat^[CurrentMatrix]^.howmanycols-screenW then
							begin
								gotoxy(1,1);
								outa:=outa+1;
								outd:=outd+1;
								shownotall(Matxs.mat^[CurrentMatrix]^,outw,outs,outa,outd,k,l);
								hortmacht(i,i,outw,outa,j);
							end;
		#8:begin//Backspase, помощь
				TextBackGround(1);
				clrscr;
				gotoxy(1,1);
				writeln('Перемещение по матрице-w,s,a,d , выбор элемента-стрелками. R- Считать матрицу из файла, F- Сохранить матрицу в файл. Скроллинг - tab');
				readln;
				redaction
			end;
		'r','R','к','К':begin//Чтение
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
								writeln('Текущий элемент ',Matxs.mat^[CurrentMatrix]^.showme(i,j),'  Backspase-помощь.');
								gotoxy(1,screenH);
								writeln('Матрица № ',CurrentMatrix);
								gotoxy(13,screenH);
								writeln('Индексы: ',i:3,' ',j:3)
							end
							else
								writeln('Нажиите R для чтения матрицы из файла или Esc для выхода.');
						end;
		'а','А','F','f':begin//Сохранение
							gotomenu(8,CurrentMatrix);
							TextBackGround(1);
							clrscr;
							shownotall(Matxs.mat^[CurrentMatrix]^,outw,outs,outa,outd,k,l);
							gotoxy(1,screenH-1);
							writeln('Текущий элемент ',Matxs.mat^[CurrentMatrix]^.showme(i,j),'  Backspase-помощь.');
							gotoxy(1,screenH);
							writeln('Матрица № ',CurrentMatrix);
							gotoxy(13,screenH);
							writeln('Индексы: ',i:3,' ',j:3)
						end;
					#9:begin//Tab
							
						end;
			end
		end
	end
end;

procedure creation;//Создание матрицы
var
	i,j:integer;
begin
	TextBackGround(1);
	clrscr;
	writeln('Введите кол-во столбцов, строк.');
	repeat
			{$I-}
		readln(i,j);
			{$I+}
	until ioresult=0;
	inc(Matxs.max);
	CurrentMatrix:=Matxs.max;
	getmem(Matxs.mat^[CurrentMatrix],sizeof(matrix));
	Matxs.mat^[CurrentMatrix]^.create(i,j);
	if request('Заполнить таблицу случайными числами') then
		begin
			randomize;
			for i:=1 to Matxs.mat^[CurrentMatrix]^.howmanycols do
				for j:=1 to Matxs.mat^[CurrentMatrix]^.howmanyrows do
					Matxs.mat^[CurrentMatrix]^.wochanges(i,j,random*100-50)
		end
end;

procedure Deletion;//Удаление матрицы CurrentMatrix
var
i:byte;
s:string;
begin
	TextBackGround(1);
	clrscr;
if CurrentMatrix<>0 then
	begin
	str(CurrentMatrix,s);
	if request('Вы действительно хотите удалить матрицу '+s) then
		begin
			Matxs.mat^[CurrentMatrix]^.destroy;
			For i:=CurrentMatrix to Matxs.max do
				Matxs.mat^[i]:=Matxs.mat^[i+1];
			dec(matxs.max);
			TextBackGround(1);
			clrscr;
			writeln('Удаление прошло успешно.');
			readln;
			CurrentMatrix:=0
		end
	end
	else
	begin
		writeln('Матрица не выбрана.');
		readln
	end
end;

procedure shellsort;//Сортировка Шелла
var
s:string;
begin
	str(CurrentMatrix,s);
		TextBackGround(1);
		clrscr;
	if (CurrentMatrix<>0)and(request('Вы действительно хотите отсортировать матрицу '+s)) then
	begin
		writeln(Matxs.mat^[CurrentMatrix]^.showmekeys(k,l));
		Matxs.mat^[CurrentMatrix]^.shellsort;
		Writeln(Matxs.mat^[CurrentMatrix]^.showmekeys(k,l));
		writeln('Сортировка закончена!');
			readln;
	end
		else
		if CurrentMatrix =0 then
			writeln('Матрица не выбрана.');
end;

procedure reading;//Чтение матрицы из файла
var
i,j:integer;
d,f:single;
fily:file of single;
filyway:string;
begin
	TextBackGround(1);
	clrscr;
	writeln('Введите имя файла, из которого хотите считать матрицу.');
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
					writeln('Матрица успешно считана с файла ', filyway);
						{$I-}
					close(fily)
						{$I+}
				end
			else
				writeln('Некорректное имя файла.');
		end
	else
		WRITELN('Файл не существует');
		readln
end;

procedure salvation;//Сохранение матрицы в файл
var
i,j:integer;
fily:file of single;
filyway:string;
begin
	TextBackGround(1);
	clrscr;
	if CurrentMatrix<>0 then
		begin
			writeln('Введите имя файла, в который будет записана матрица.');
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
				writeln('Матрица успешно сохранена в файле ', filyway);
					{$I-}
				close(fily)
					{$I+}
			end
			else
			writeln('Некорректное имя файла.');
		end
	else
		writeln('Матрица не выбрана.');
	readln;
end;

procedure gotomenu(j,d:byte);//Функция обслуживающая клавишу Enter в меню, переходит к меню под номером j, CurrentMatrix присваевает d
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
		6:if request('Вы действительно хотите выйти') then
			goodbye:=true
	end;
end;

function menind(i:byte):byte;//Вспомогательная функция для вычисления первой координаты для gotoxy от индекса i в меню
begin
menind:=7+i*3
end;

procedure vertmenu(var now,next:byte);//Функция обслуживающая передвижение по вертикали в меню
begin
gotoxy(1,now);
TextBackGround(1);
write(menushka[now]);
TextBackGround(5);
gotoxy(1,next);
write(menushka[next]);
now:=next;
end;

procedure hormenu(var now,next:byte);//Функция обслуживающая передвижение по горизонтали (выбор текущей матрицы) в меню
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

procedure menu;//Собственно, меню
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
		writeln('Выберете элемент меню');
		writeln('Создать новую таблицу');
		writeln('Удалить таблицу');
		writeln('Отсортировать по Шеллу текущую таблицу');
		writeln('Редактировать таблицу');
		writeln('...Я передумал(а)');
		gotoxy(1,screenH);
		writeln('Backspace-помощь.');
		gotoxy(1,screenH-1);
		write('Матрица: ');
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
				#72:if j>2 then//Вверх
						begin
							nextv:=j-1;
							vertmenu(j,nextv);
						end
					else
						begin
							nextv:=menmax;
							vertmenu(j,nextv);
						end;
				#80:if j<menmax then//Вниз
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
				#75:if  Matxs.max<>0 then//Влево
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
				#77:if Matxs.max<>0 then//Вправо
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
						writeln('Выбор матрицы: вправо, влево, перемещение по меню: вверх, вниз.');
						writeln('Кол-во столбцов в редакторе: ',screenW,' Столбцов ',screenH-2,' С параметрами вывода ',k,' ',l,' (Всего, после запятой.)');
						writeln('Параметры экрана меняются в screen.txt');
						readln;
						menu;
					end;
				end
			end
	end;
end;

begin
	CurrentMatrix:=0;//Инициализация всего
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
	if gibtes(screenway) then//Чтение конфиг-файла
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
	if	(l<3)or(l>15) then//Ре-инициализация параметров экрана при некорректном вводе
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
        menu//Все слишком просто, понятно и логично.
    until goodbye=true;
	clrscr;
	writeln('"Нейтральное по стилю прощание"!');
	readln
end.