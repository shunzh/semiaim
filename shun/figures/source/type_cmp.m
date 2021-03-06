function retval = average(vector)
	retval = sum(vector) / length(vector);
endfunction

function retval = confidence(vector)
	retval = 1.96 * std(vector) / sqrt(length(vector));
endfunction

function retval = format(float)
	retval = num2str(float,'%1.2f');
endfunction

% draw the 
function retval = constructDelayVector(trafficLevel, redPhase, b, c, d, e)
	fileName = ["delay_result_d_restart/delay_result_for_human_", format(trafficLevel), "_", format(e), "_", format(d) ,"_", format(c), "_", format(b) , "_", format(redPhase), "-f.csv"];
	if (exist(fileName) == 0)
		disp(["Missing: ", fileName]);
		retval = [];
		return;
	endif

	disp(["Saw: ", fileName]);
	fileHandle = csvread(fileName);

	% take out the average delay
	delay = fileHandle(:, 1);

	% return [x, average of delay, confidence of delay]
	retval = [1 - e, average(delay), confidence(delay)];
endfunction

% read result from csv files
function retval = readResult (trafficLevel, redPhase)
% A
	result = [];
	b = 0;
	c = 0;
	d = 0;
	for e = [0: 0.05: 1]
		result = [result; constructDelayVector(trafficLevel, redPhase, b, c, d, e)];
	endfor
        eb = errorbar(result(:, 1), result(:, 2), result(:, 3));
	set(eb, "marker", "*");
	set(eb, "markersize", 12);
	set(eb, "color", "black");
	save("2.csv", "result");
	hold on;

% B
	result = [];
	c = 0;
	d = 0;
	for e = [0: 0.05: 1]
		b = 1 - e;
		result = [result; constructDelayVector(trafficLevel, redPhase, b, c, d, e)];
	endfor
        eb = errorbar(result(:, 1), result(:, 2), result(:, 3));
	set(eb, "marker", "o");
	set(eb, "markersize", 12);
	set(eb, "color", "r");
	save("-append", "2.csv", "result");
	hold on;

% C
	result = [];
	b = 0;
	d = 0;
	for e = [0: 0.05: 1]
		c = 1 - e;
		result = [result; constructDelayVector(trafficLevel, redPhase, b, c, d, e)];
	endfor
        eb = errorbar(result(:, 1), result(:, 2), result(:, 3));
	set(eb, "marker", "+");
	set(eb, "markersize", 12);
	set(eb, "color", "g");
	save("-append", "2.csv", "result");
	hold on;

% D
	result = [];
	b = 0;
	c = 0;
	for e = [0: 0.05: 1]
		d = 1 - e;
		result = [result; constructDelayVector(trafficLevel, redPhase, b, c, d, e)];
	endfor
        eb = errorbar(result(:, 1), result(:, 2), result(:, 3));
	set(eb, "marker", "x");
	set(eb, "markersize", 12);
	set(eb, "color", "m");
	save("-append", "2.csv", "result");
	hold on;
endfunction

% =============== main ===============
trafficLevel = 0.1;

result = readResult(trafficLevel, 5); % redPhase is 5 by default
save("-append", "2.csv", "result");
hold on;


% draw baseline - traffic signal (no autonomous vehicles at all)
fileName = ["delay_result_d_restart/delay_result_for_human_", format(trafficLevel), "_1.00_0.00_0.00_0.00_5.00-f.csv"];
fileHandle = csvread(fileName);
fileHandle = fileHandle(:, 1);
delayTime = average(fileHandle);
errorVal = confidence(fileHandle);
result = [[0: 0.05: 1]', ones(21, 1) .* delayTime, ones(21, 1) .* errorVal];
plot(result(:, 1), result(:, 2), "color", "blue");
save("-append", "2.csv", "result");

% decorate graph
xlabel('(Semi-)Autonomous Vehicles Ratio','fontsize',18);
ylabel('Average Delay (s)','fontsize',18);
axis([0 1 0 45]);
legend('Type A', 'Type SA-ACC', 'Type SA-CC', 'Type SA-Com', 'Type H', 'location', 'southwest');
set(gca,'fontsize',16);
%print('figure_1.png', '-S800,500');
print('figure_1.eps', '-color', '-S400,250');
close;
