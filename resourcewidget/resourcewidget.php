<style>
	.sys_procs {
		font-family: monospace;
		width: calc(100% - 28px);
		margin: 0 auto;
		padding: 14px;
		text-align: left;
		background: #000;
		color: green;
		word-break: break-all;
	}
	.sys_procs table {
		border-collapse: collapse;
		width: 100%;
	}
	.sys_procs td {
		outline: none;
		padding: 0;
		color: #01a9ac;
		min-width: 75px;
		text-align: left;
		font-family: monospace
	}
	.sys_procs td.command {
		color: green;
	}
	.sys_procs thead tr {
		background-color: green;
	}
	.sys_procs thead tr th {
		color: #000;
		text-align: left;
		font-family: monospace;
	}
	.sys_procs .label {
		color: #01a9ac;
	}
	@media (max-width:600px) {
		.sys_procs tr th:nth-child(1),
		.sys_procs tr th:nth-child(2),
		.sys_procs tr th:nth-child(5),
		.sys_procs tr td:nth-child(1),
		.sys_procs tr td:nth-child(2),
		.sys_procs tr td:nth-child(5) {
			display: none;
		}
	}
</style>

<div class="sys_procs">
	<span class="label">Tasks: </span>
	<span class="value"><?=shell_exec('ps -A --no-headers | wc -l')?></span>
	<br>
	<span class="label">Load average: </span>
	<span class="value"><?=shell_exec("uptime | awk -F': ' '{print $2}'")?></span>
	<br>
	<span class="label">Uptime: </span>
	<span class="value"><?=shell_exec('uptime -p | cut -d " " -f2-')?></span>
	<br><br>
	<table>
		<thead>
			<tr>
				<th>PID</th>
				<th>USER</th>
				<th>%CPU</th>
				<th>%MEM</th>
				<th>TIME</th>
				<th>COMMAND</th>
			</tr>
		</thead>
		<tbody>
<?php
$output = shell_exec('ps -Ao pid,user,%cpu,%mem,time,command --sort -%mem --no-headers | head -20');

foreach(explode(PHP_EOL, $output) as $line):
	$arr = preg_split('/ +/', $line, null, PREG_SPLIT_NO_EMPTY);
	$command = join(' ', array_slice($arr, 5)); ?>
			<tr>
				<td><?php if(isset($arr[0])) { echo $arr[0]; } ?></td>
				<td><?php if(isset($arr[0])) { echo $arr[1]; } ?></td>
				<td><?php if(isset($arr[0])) { echo $arr[2]; } ?></td>
				<td><?php if(isset($arr[0])) { echo $arr[3]; } ?></td>
				<td><?php if(isset($arr[0])) { echo $arr[4]; } ?></td>
				<td class="command"><?= $command ?></td>
			</tr>
<?php endforeach ?>
		</tbody>
	</table>
</div>
