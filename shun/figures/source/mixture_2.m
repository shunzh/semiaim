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
	fileName = ["delay_result_mix/delay_result_for_human_", format(trafficLevel), "_", format(e), "_", format(d) ,"_", format(c), "_", format(b) , "_", format(redPhase), "-f.csv"];
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
	retval = [1 - b - c - d - e, average(delay), confidence(delay)];
endfunction

% read result from csv files
function retval = readResult (trafficLevel, redPhase)
	result_b = []; result_c = []; result_d = [];
	e = 0.10;
	x = 0.85;
	a = 0.05;
	for caseNum = [0 : 16]
		result_b = [result_b; constructDelayVector(trafficLevel, redPhase, x, 0, 0, e)];
		result_c = [result_c; constructDelayVector(trafficLevel, redPhase, 0, x, 0, e)];
		result_d = [result_d; constructDelayVector(trafficLevel, redPhase, 0, 0, x, e)];
		x -= 0.05; a += 0.05;
	endfor

	eb = errorbar(result_b(:, 1), result_b(:, 2), result_b(:, 3));
	set(eb, "marker", "o");
	set(eb, "markersize", 15);
	set(eb, "color", "r");
	save("4.csv", "result_b");
	hold on;

	eb = errorbar(result_c(:, 1), result_c(:, 2), result_c(:, 3));
	set(eb, "marker", "+");
	set(eb, "markersize", 15);
	set(eb, "color", "g");
	save("-append", "4.csv", "result_c");
	hold on;

	eb = errorbar(result_d(:, 1), result_d(:, 2), result_d(:, 3));
	set(eb, "marker", "x");
	set(eb, "markersize", 15);
	set(eb, "color", "m");
	save("-append", "4.csv", "result_d");
	hold on;

	endfunction

% =============== main ===============
trafficLevel = 0.1;

readResult(trafficLevel, 5); % redPhase is 5 by default
hold on;

% draw baseline - traffic signal (no autonomous vehicles at all)
fileName = ["delay_result_d_restart/delay_result_for_human_", format(trafficLevel), "_1.00_0.00_0.00_0.00_5.00-f.csv"];
fileHandle = csvread(fileName);
fileHandle = fileHandle(:, 1);
delayTime = average(fileHandle);
errorVal = confidence(fileHandle);
result = [[0: 0.05: 1]', ones(21, 1) .* delayTime, ones(21, 1) .* errorVal];
plot(result(:, 1), result(:, 2), "color", "blue");
save("-append", "4.csv", "result");

% decorate graph
xlabel('Autonomous Vehicles Ratio','fontsize',18);
ylabel('Average Delay (s)','fontsize',18);
axis([0, 1, 10, 45]);
legend('Mix of A, SA-ACC, H', 'Mix of A, SA-CC, H', 'Mix of A, SA-Com, H', 'SIGNAL', 'location', 'southwest');
set(gca,'fontsize',16);
%print(['mixture_2_', num2str(trafficLevel), '.png'], '-S700,500');
print('figure_3.eps', '-color', '-S400,250');
close;
