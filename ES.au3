#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=..\asd.Exe
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs ----------------------------------------------------------------------------

	AutoIt Version: 3.3.15.0 (Beta)
	Author:         Borja Live

	UDF Function:
	Simulacion de algoritmos de remplazo

#ce ----------------------------------------------------------------------------

#include <Array.au3>

#Region CONSTTANTS
$ES_ALGORITHM_FCFS = 1
$ES_ALGORITHM_SSTF = 2
$ES_ALGORITHM_SCAN = 3
$ES_ALGORITHM_LOOK = 4
$ES_ALGORITHM_SCANN = 5
$ES_ALGORITHM_LOOKN = 6
$ES_ALGORITHM_FSCAN = 7
$ES_ALGORITHM_FLOOK = 8
$ES_ALGORITHM_CSCAN = 9
$ES_ALGORITHM_CLOOK = 10
#Region ERRORS
$ERROR_NO_ERROR = 0
#EndRegion ERRORS
#Region DOCUMENTATION
#cs
	INICIALIZATION:
		$tracks
			[entry][data]
			0 = instant
			1 = [tracs]
		$initialTrack
			number
		$initialDirection
			True = UP
			False = DOWN
		$instantAvanceWay
			[2]
			0 = Avance [1] each row
			1 = Avance [1] each request
			2 = Avance [1] each track move
		$firstTrack
			number
		$finalTrack
			number
	RESOULT:
	[row][data]
	0 = instant
	1 = queue
	2 = current track
	3 = current direction
	4 = next track
	5 = tracks moved
#ce
#EndRegion DOCUMENTATION
#EndRegion CONSTTANdTS

;____Test1($ES_ALGORITHM_FCFS)
;____Test1($ES_ALGORITHM_SSTF)
;____Test1($ES_ALGORITHM_SCAN)
;____Test1($ES_ALGORITHM_LOOK)
;____Test1($ES_ALGORITHM_SCANN)
;____Test1($ES_ALGORITHM_LOOKN)
;____Test1($ES_ALGORITHM_FSCAN)
;____Test1($ES_ALGORITHM_FLOOK)
;____Test1($ES_ALGORITHM_CSCAN)
;____Test1($ES_ALGORITHM_CLOOK)
;____TEST_EJ1()
;____TEST_EJ2()
;____TEST_EJ3()
;____TEST_EJ4()
;____TEST_EJ5()
;____TEST_EJ6()
;____TEST_EJ9()
;____TEST_EJ10()
;____TEST_EJ11()
;____TEST_EJ12()
;____TEST_EJ13()
;____TEST_EJ14()

#Region INTERFACE
Func _ESsolve($algorithm, $tracks, $initialTrack, $initialDirection, $instantAvanceWay, $firstTrack, $finalTrack, $Nvalue = 4, $readDirection = True)
	;Crear estructura
	Dim $resoult[1][6]
	$resoult[0][0] = 0
	$resoult[0][1] = ___QUEUEcreate()
	$resoult[0][2] = $initialTrack
	$resoult[0][3] = $initialDirection


	;Ejecutar el algoritmo
	Switch ($algorithm)
		Case $ES_ALGORITHM_FCFS
			__ES_FCFS_SSTF($tracks, $instantAvanceWay, $firstTrack, $finalTrack, $resoult, True)
		Case $ES_ALGORITHM_SSTF
			__ES_FCFS_SSTF($tracks, $instantAvanceWay, $firstTrack, $finalTrack, $resoult, False)
		Case $ES_ALGORITHM_SCAN
			__ES_SCAN_LOOK($tracks, $instantAvanceWay, $firstTrack, $finalTrack, $resoult, $initialDirection, True)
		Case $ES_ALGORITHM_LOOK
			__ES_SCAN_LOOK($tracks, $instantAvanceWay, $firstTrack, $finalTrack, $resoult, $initialDirection, False)
		Case $ES_ALGORITHM_SCANN
			__ES_SCANN_LOOKN($tracks, $instantAvanceWay, $firstTrack, $finalTrack, $resoult, $initialDirection, $Nvalue, True)
		Case $ES_ALGORITHM_LOOKN
			__ES_SCANN_LOOKN($tracks, $instantAvanceWay, $firstTrack, $finalTrack, $resoult, $initialDirection, $Nvalue, False)
		Case $ES_ALGORITHM_FSCAN
			__ES_FSCAN_FLOOK($tracks, $instantAvanceWay, $firstTrack, $finalTrack, $resoult, $initialDirection, True)
		Case $ES_ALGORITHM_FLOOK
			__ES_FSCAN_FLOOK($tracks, $instantAvanceWay, $firstTrack, $finalTrack, $resoult, $initialDirection, False)
		Case $ES_ALGORITHM_CSCAN
			__ES_CSCAN_CLOOK($tracks, $instantAvanceWay, $firstTrack, $finalTrack, $resoult, $initialDirection, $readDirection, True)
		Case $ES_ALGORITHM_CLOOK
			__ES_CSCAN_CLOOK($tracks, $instantAvanceWay, $firstTrack, $finalTrack, $resoult, $initialDirection, $readDirection, False)
	EndSwitch

	$total = 0
	For $i = 0 To UBound($resoult, 1)-2
		$total += $resoult[$i][5]
	Next
	$resoult[UBound($resoult, 1)-1][4] = "TOTAL:"
	$resoult[UBound($resoult, 1)-1][5] = $total


	If @error Then SetError(@error, @extended, $resoult)
	Return $resoult
EndFunc   ;==>_MMUsolve
#EndRegion INTERFACE

#Region SUB_UDF
Func __ES_FCFS_SSTF($tracks, $instantAvanceWay, $firstTrack, $finalTrack, ByRef $resoult, $FCFS_SSTF)
	$row = 0
	___AddTracks($resoult[$row][1], $tracks, $resoult[$row][0])
	While Not ___QUEUEisEmpty($resoult[$row][1])
		$saveQueue = $resoult[$row][1]
		If $FCFS_SSTF Then
			$nextTrack = ___FindNext_FCFS($resoult[$row][1])
		Else
			$nextTrack = ___FindNext_SSTF($resoult[$row][1], $resoult[$row][2])
		EndIf
		$resoult[$row][4] = $nextTrack
		$resoult[$row][5] = Abs($resoult[$row][2] - $resoult[$row][4])
		$nextInstant = ___InstantAvance($resoult[$row][0], $resoult[$row][5], True, $instantAvanceWay)
		$row += 1
		ReDim $resoult[$row+1][6]
		$resoult[$row][0] = $nextInstant
		$resoult[$row][1] = $resoult[$row-1][1]
		$resoult[$row-1][1] = $saveQueue
		$resoult[$row][2] = $nextTrack
		___AddTracks($resoult[$row][1], $tracks, $resoult[$row][0])
	WEnd
EndFunc
Func __ES_SCAN_LOOK($tracks, $instantAvanceWay, $firstTrack, $finalTrack, ByRef $resoult, $initialDirection, $SCAN_LOOK)
	$row = 0
	___AddTracks($resoult[$row][1], $tracks, $resoult[$row][0])
	While Not ___QUEUEisEmpty($resoult[$row][1])
		;_ArrayDisplay($resoult)
		$saveQueue = $resoult[$row][1]
		$nextTrack = ___FindNext_ELEVATOR($resoult[$row][1], $resoult[$row][2], $resoult[$row][3])
		If $nextTrack == -1 Then
			;Cambiar de direccion
			If $SCAN_LOOK Then
				If $resoult[$row][3] Then
					$resoult[$row][4] = $finalTrack
				Else
					$resoult[$row][4] = $firstTrack
				EndIf
				$resoult[$row][5] = Abs($resoult[$row][2] - $resoult[$row][4])
				$nextInstant = ___InstantAvance($resoult[$row][0], $resoult[$row][5], False, $instantAvanceWay)
				$row += 1
				ReDim $resoult[$row+1][6]
				$resoult[$row][0] = $nextInstant
				$resoult[$row][1] = $resoult[$row-1][1]
				$resoult[$row][2] = $resoult[$row-1][4]
				___AddTracks($resoult[$row][1], $tracks, $resoult[$row][0])
			EndIf
			$resoult[$row][3] = Not $resoult[$row-1][3]
			$nextTrack = ___FindNext_ELEVATOR($resoult[$row][1], $resoult[$row][2], $resoult[$row][3])
		EndIf

		$resoult[$row][4] = $nextTrack
		$resoult[$row][5] = Abs($resoult[$row][2] - $resoult[$row][4])
		$nextInstant = ___InstantAvance($resoult[$row][0], $resoult[$row][5], True, $instantAvanceWay)
		$row += 1
		ReDim $resoult[$row+1][6]
		$resoult[$row][0] = $nextInstant
		$resoult[$row][1] = $resoult[$row-1][1]
		$resoult[$row-1][1] = $saveQueue
		$resoult[$row][2] = $nextTrack
		If $resoult[$row-1][2] == $resoult[$row-1][4] Then
			$resoult[$row][3] = $resoult[$row-1][3]
		Else
			$resoult[$row][3] = $resoult[$row-1][2] < $resoult[$row-1][4]
		EndIf
		___AddTracks($resoult[$row][1], $tracks, $resoult[$row][0])
	WEnd
EndFunc
Func __ES_SCANN_LOOKN($tracks, $instantAvanceWay, $firstTrack, $finalTrack, ByRef $resoult, $initialDirection, $Nvalue, $SCAN_LOOK)
	$row = 0
	$innerQueue = ___QUEUEcreate()
	___AddTracks($resoult[$row][1], $tracks, $resoult[$row][0])
	___QUEUEpour($innerQueue, $resoult[$row][1], $Nvalue)
	While Not ___QUEUEisEmpty($resoult[$row][1])
		;_ArrayDisplay($resoult)
		$saveQueue = $resoult[$row][1]
		$nextTrack = ___FindNext_ELEVATOR($innerQueue, $resoult[$row][2], $resoult[$row][3])
		If $nextTrack == -1 Then
			;Cambiar de direccion
			If $SCAN_LOOK Then
				If $resoult[$row][3] Then
					$resoult[$row][4] = $finalTrack
				Else
					$resoult[$row][4] = $firstTrack
				EndIf
				$resoult[$row][5] = Abs($resoult[$row][2] - $resoult[$row][4])
				$nextInstant = ___InstantAvance($resoult[$row][0], $resoult[$row][5], False, $instantAvanceWay)
				$row += 1
				ReDim $resoult[$row+1][6]
				$resoult[$row][0] = $nextInstant
				$resoult[$row][1] = $resoult[$row-1][1]
				$resoult[$row][2] = $resoult[$row-1][4]
				___AddTracks($resoult[$row][1], $tracks, $resoult[$row][0])
			EndIf
			$resoult[$row][3] = Not $resoult[$row-1][3]
			$nextTrack = ___FindNext_ELEVATOR($innerQueue, $resoult[$row][2], $resoult[$row][3])
		EndIf
		___QUEUEdelete($resoult[$row][1], $nextTrack)

		$resoult[$row][4] = $nextTrack
		$resoult[$row][5] = Abs($resoult[$row][2] - $resoult[$row][4])
		$nextInstant = ___InstantAvance($resoult[$row][0], $resoult[$row][5], True, $instantAvanceWay)
		$row += 1
		ReDim $resoult[$row+1][6]
		$resoult[$row][0] = $nextInstant
		$resoult[$row][1] = $resoult[$row-1][1]
		$resoult[$row-1][1] = $saveQueue
		$resoult[$row][2] = $nextTrack
		If $resoult[$row-1][2] == $resoult[$row-1][4] Then
			$resoult[$row][3] = $resoult[$row-1][3]
		Else
			$resoult[$row][3] = $resoult[$row-1][2] < $resoult[$row-1][4]
		EndIf
		___AddTracks($resoult[$row][1], $tracks, $resoult[$row][0])
		If ___QUEUEisEmpty($innerQueue) Then ___QUEUEpour($innerQueue, $resoult[$row][1], $Nvalue)
	WEnd
EndFunc
Func __ES_FSCAN_FLOOK($tracks, $instantAvanceWay, $firstTrack, $finalTrack, ByRef $resoult, $initialDirection, $SCAN_LOOK)
	$row = 0
	$innerQueue = ___QUEUEcreate()
	___AddTracks($resoult[$row][1], $tracks, $resoult[$row][0])
	$innerQueue = $resoult[$row][1]
	While Not ___QUEUEisEmpty($resoult[$row][1])
		;_ArrayDisplay($resoult)
		$saveQueue = $resoult[$row][1]
		$nextTrack = ___FindNext_ELEVATOR($innerQueue, $resoult[$row][2], $resoult[$row][3])
		If $nextTrack == -1 Then
			;Cambiar de direccion
			If $SCAN_LOOK Then
				If $resoult[$row][3] Then
					$resoult[$row][4] = $finalTrack
				Else
					$resoult[$row][4] = $firstTrack
				EndIf
				$resoult[$row][5] = Abs($resoult[$row][2] - $resoult[$row][4])
				$nextInstant = ___InstantAvance($resoult[$row][0], $resoult[$row][5], False, $instantAvanceWay)
				$row += 1
				ReDim $resoult[$row+1][6]
				$resoult[$row][0] = $nextInstant
				$resoult[$row][1] = $resoult[$row-1][1]
				$resoult[$row][2] = $resoult[$row-1][4]
				___AddTracks($resoult[$row][1], $tracks, $resoult[$row][0])
			EndIf
			$resoult[$row][3] = Not $resoult[$row-1][3]
			$nextTrack = ___FindNext_ELEVATOR($innerQueue, $resoult[$row][2], $resoult[$row][3])
		EndIf
		___QUEUEdelete($resoult[$row][1], $nextTrack)

		$resoult[$row][4] = $nextTrack
		$resoult[$row][5] = Abs($resoult[$row][2] - $resoult[$row][4])
		$nextInstant = ___InstantAvance($resoult[$row][0], $resoult[$row][5], True, $instantAvanceWay)
		$row += 1
		ReDim $resoult[$row+1][6]
		$resoult[$row][0] = $nextInstant
		$resoult[$row][1] = $resoult[$row-1][1]
		$resoult[$row-1][1] = $saveQueue
		$resoult[$row][2] = $nextTrack
		If $resoult[$row-1][2] == $resoult[$row-1][4] Then
			$resoult[$row][3] = $resoult[$row-1][3]
		Else
			$resoult[$row][3] = $resoult[$row-1][2] < $resoult[$row-1][4]
		EndIf
		___AddTracks($resoult[$row][1], $tracks, $resoult[$row][0])
		If ___QUEUEisEmpty($innerQueue) Then $innerQueue = $resoult[$row][1]
	WEnd
EndFunc
Func __ES_CSCAN_CLOOK($tracks, $instantAvanceWay, $firstTrack, $finalTrack, ByRef $resoult, $initialDirection, $readDirection, $SCAN_LOOK)
	$row = 0
	___AddTracks($resoult[$row][1], $tracks, $resoult[$row][0])
	While Not ___QUEUEisEmpty($resoult[$row][1])
		;_ArrayDisplay($resoult)
		$saveQueue = $resoult[$row][1]
		$nextTrack = ___FindNext_ELEVATOR($resoult[$row][1], $resoult[$row][2], $readDirection)
		If $nextTrack == -1 Then
			;Cambiar de direccion
			If $SCAN_LOOK Then
				If $readDirection Then
					$resoult[$row][4] = $finalTrack
				Else
					$resoult[$row][4] = $firstTrack
				EndIf
				$resoult[$row][5] = Abs($resoult[$row][2] - $resoult[$row][4])
				$nextInstant = ___InstantAvance($resoult[$row][0], $resoult[$row][5], False, $instantAvanceWay)
				$row += 1
				ReDim $resoult[$row+1][6]
				$resoult[$row][0] = $nextInstant
				$resoult[$row][1] = $resoult[$row-1][1]
				$resoult[$row][2] = $resoult[$row-1][4]
				___AddTracks($resoult[$row][1], $tracks, $resoult[$row][0])
			EndIf
			If $SCAN_LOOK Then
				$resoult[$row][3] = Not $resoult[$row-1][3]
				If $readDirection Then
					$resoult[$row][4] = $firstTrack
				Else
					$resoult[$row][4] = $finalTrack
				EndIf
				$resoult[$row][5] = Abs($resoult[$row][2] - $resoult[$row][4])
				$nextInstant = ___InstantAvance($resoult[$row][0], $resoult[$row][5], False, $instantAvanceWay)
				$row += 1
				ReDim $resoult[$row+1][6]
				$resoult[$row][0] = $nextInstant
				$resoult[$row][1] = $resoult[$row-1][1]
				$resoult[$row][2] = $resoult[$row-1][4]
				___AddTracks($resoult[$row][1], $tracks, $resoult[$row][0])
			Else
				$resoult[$row][3] = Not $resoult[$row-1][3]
				$queue = $resoult[$row][1]
				If $readDirection Then
					$lowest = $finalTrack
					For $i = 1 To $queue[0]
						If $queue[$i] < $lowest Then $lowest = $queue[$i]
					Next
					$resoult[$row][4] = $lowest
				Else
					$highest = $firstTrack
					For $i = 1 To $queue[0]
						If $queue[$i] > $highest Then $highest = $queue[$i]
					Next
					$resoult[$row][4] = $highest
				EndIf
				$resoult[$row][5] = Abs($resoult[$row][2] - $resoult[$row][4])
				$nextInstant = ___InstantAvance($resoult[$row][0], $resoult[$row][5], False, $instantAvanceWay)
				$row += 1
				ReDim $resoult[$row+1][6]
				$resoult[$row][0] = $nextInstant
				$resoult[$row][1] = $resoult[$row-1][1]
				$resoult[$row][2] = $resoult[$row-1][4]
				___AddTracks($resoult[$row][1], $tracks, $resoult[$row][0])
			EndIf

			$resoult[$row][3] = Not $resoult[$row-1][3]
			$nextTrack = ___FindNext_ELEVATOR($resoult[$row][1], $resoult[$row][2], $readDirection)
		EndIf

		$resoult[$row][4] = $nextTrack
		$resoult[$row][5] = Abs($resoult[$row][2] - $resoult[$row][4])
		$nextInstant = ___InstantAvance($resoult[$row][0], $resoult[$row][5], True, $instantAvanceWay)
		$row += 1
		ReDim $resoult[$row+1][6]
		$resoult[$row][0] = $nextInstant
		$resoult[$row][1] = $resoult[$row-1][1]
		$resoult[$row-1][1] = $saveQueue
		$resoult[$row][2] = $nextTrack
		If $resoult[$row-1][2] == $resoult[$row-1][4] Then
			$resoult[$row][3] = $resoult[$row-1][3]
		Else
			$resoult[$row][3] = $resoult[$row-1][2] < $resoult[$row-1][4]
		EndIf
		___AddTracks($resoult[$row][1], $tracks, $resoult[$row][0])
	WEnd
EndFunc

Func ___FindNext_FCFS(ByRef $queue)
	$bestTrack = $queue[1]
	___QUEUEdelete($queue, $bestTrack)
	Return $bestTrack
EndFunc
Func ___FindNext_SSTF(ByRef $queue, $currentTrack)
	$bestTrack = -1
	$bestDistance = -1
	$bestI = - 1

	For $i = 1 To $queue[0]
		If $bestDistance = -1 OR $bestDistance > Abs($queue[$i]-$currentTrack) Then
			$bestDistance =  Abs($queue[$i]-$currentTrack)
			$bestTrack = $queue[$i]
			$bestI = $i
		EndIf
	Next

	___QUEUEdelete($queue, $bestTrack)

	Return $bestTrack
EndFunc
Func ___FindNext_ELEVATOR(ByRef $queue, $currentTrack, $currentDirection)
	$bestTrack = -1
	$bestDistance = -1
	$bestI = - 1

	For $i = 1 To $queue[0]
		If (($queue[$i] >= $currentTrack AND $currentDirection) OR ($queue[$i] <= $currentTrack AND NOT $currentDirection)) AND ($bestDistance = -1 OR $bestDistance > Abs($queue[$i]-$currentTrack)) Then
			$bestDistance =  Abs($queue[$i]-$currentTrack)
			$bestTrack = $queue[$i]
			$bestI = $i
		EndIf
	Next

	If $bestTrack == -1 Then Return -1
	___QUEUEdelete($queue, $bestTrack)

	Return $bestTrack
EndFunc

Func ___AddTracks(ByRef $queue, ByRef $tracks, $instant)
	;_ArrayDisplay($queue)
	For $i = 0 To UBound($tracks, 1)-1
		If $tracks[$i][0] >= 0 And $tracks[$i][0] <= $instant Then
			$tracks[$i][0] = -1
			$list = $tracks[$i][1]
			For $j = 0 To UBound($list)-1
				___QUEUEadd($queue, $list[$j])
			Next
		EndIf
	Next
	;_ArrayDisplay($queue)
EndFunc
Func ___InstantAvance($currentInstant, $tracksElapsed, $requestSolved, $instantAvanceWay)
	Switch $instantAvanceWay[0]
		Case 0
			$currentInstant += $instantAvanceWay[1]
		Case 1
			If $requestSolved Then $currentInstant += $instantAvanceWay[1]
		Case 2
			$currentInstant += $instantAvanceWay[1]*$tracksElapsed
	EndSwitch

	Return $currentInstant
EndFunc

Func ___QUEUEcreate()
	Dim $queue[1]
	$queue[0] = 0
	Return $queue
EndFunc
Func ___QUEUEadd(ByRef $queue, $track)
	$queue[0] += 1
	ReDim $queue[$queue[0]+1]
	$queue[$queue[0]] = $track
EndFunc
Func ___QUEUEdelete(ByRef $queue, $track)
	For $i = ___QUEUEsearch($queue, $track) To $queue[0]-1
		$queue[$i] = $queue[$i+1]
	Next
	$queue[0] -= 1
	ReDim $queue[$queue[0]+1]
EndFunc
Func ___QUEUEsearch(ByRef $queue, $track)
	For $i = 1 To $queue[0]
		If $track = $queue[$i] Then Return $i
	Next
	Return -1
EndFunc
Func ___QUEUEisEmpty(ByRef $queue)
	Return $queue[0] == 0
EndFunc
Func ___QUEUEpour(ByRef $queue, ByRef $source, $n)
	If $n > $source[0] Then $n = $source[0]
	For $i = 1 To $n
		___QUEUEadd($queue, $source[$i])
	Next
EndFunc
#EndRegion SUB_UDF


#Region TESTS
Func ____Test1($algorithm)
	Dim $list1 = [98, 183, 37, 122, 14, 124, 65, 67]
	Dim $tracks[1][2]
	$tracks[0][0] = 0
	$tracks[0][1] = $list1
	Dim $avanceWay[2]
	$avanceWay[0] = 1
	$avanceWay[1] = 1

	$resoult = _ESsolve($algorithm, $tracks, 53, False, $avanceWay, 0, 199, 4, True)
	_ArrayDisplay($resoult)
EndFunc
Func ____TEST_EJ1()
	Dim $list1 = [45, 90, 130, 200, 223, 415, 133, 22, 50, 60]
	Dim $tracks[1][2]
	$tracks[0][0] = 0
	$tracks[0][1] = $list1
	Dim $avanceWay[2]
	$avanceWay[0] = 1
	$avanceWay[1] = 1

	$resoult = _ESsolve($ES_ALGORITHM_SSTF, $tracks, 300, True, $avanceWay, 1, 512)
	_ArrayDisplay($resoult)
	$resoult = _ESsolve($ES_ALGORITHM_CSCAN, $tracks, 300, True, $avanceWay, 1, 512)
	_ArrayDisplay($resoult)
	$resoult = _ESsolve($ES_ALGORITHM_LOOK, $tracks, 300, True, $avanceWay, 1, 512)
	_ArrayDisplay($resoult)
EndFunc
Func ____TEST_EJ2()
	Dim $list0 = [10]
	Dim $list1 = [19]
	Dim $list2 = [3]
	Dim $list3 = [14]
	Dim $list6 = [12]
	Dim $list7 = [9]
	Dim $tracks[6][2]
	$tracks[0][0] = 0
	$tracks[0][1] = $list0
	$tracks[1][0] = 1
	$tracks[1][1] = $list1
	$tracks[2][0] = 2
	$tracks[2][1] = $list2
	$tracks[3][0] = 3
	$tracks[3][1] = $list3
	$tracks[4][0] = 6
	$tracks[4][1] = $list6
	$tracks[5][0] = 7
	$tracks[5][1] = $list7
	Dim $avanceWay[2]
	$avanceWay[0] = 1
	$avanceWay[1] = 5

	$resoult = _ESsolve($ES_ALGORITHM_LOOK, $tracks, 10, True, $avanceWay, 1, 255)
	_ArrayDisplay($resoult)
	$resoult = _ESsolve($ES_ALGORITHM_FLOOK, $tracks, 10, True, $avanceWay, 1, 255)
	_ArrayDisplay($resoult)
EndFunc
Func ____TEST_EJ3()
	Dim $list1 = [75, 43, 28, 17, 66, 82]
	Dim $tracks[1][2]
	$tracks[0][0] = 0
	$tracks[0][1] = $list1
	Dim $avanceWay[2]
	$avanceWay[0] = 1
	$avanceWay[1] = 1

	$resoult = _ESsolve($ES_ALGORITHM_SSTF, $tracks, 50, True, $avanceWay, 1, 99)
	_ArrayDisplay($resoult)
	$resoult = _ESsolve($ES_ALGORITHM_SCAN, $tracks, 50, True, $avanceWay, 1, 99)
	_ArrayDisplay($resoult)
	$resoult = _ESsolve($ES_ALGORITHM_LOOK, $tracks, 50, True, $avanceWay, 0, 99)
	_ArrayDisplay($resoult)
EndFunc
Func ____TEST_EJ4()
	Dim $list1 = [55, 58, 39, 18, 90, 150, 38, 184]
	Dim $tracks[1][2]
	$tracks[0][0] = 0
	$tracks[0][1] = $list1
	Dim $avanceWay[2]
	$avanceWay[0] = 1
	$avanceWay[1] = 1

	$resoult = _ESsolve($ES_ALGORITHM_FCFS, $tracks, 0, True, $avanceWay, 0, 199)
	_ArrayDisplay($resoult)
	$resoult = _ESsolve($ES_ALGORITHM_CSCAN, $tracks, 0, True, $avanceWay, 0, 199)
	_ArrayDisplay($resoult)

	Dim $list1 = [27, 129, 41, 186, 10, 64]
	Dim $tracks[1][2]
	$tracks[0][0] = 0
	$tracks[0][1] = $list1
	Dim $avanceWay[2]
	$avanceWay[0] = 1
	$avanceWay[1] = 1

	$resoult = _ESsolve($ES_ALGORITHM_SSTF, $tracks, 0, True, $avanceWay, 0, 199)
	_ArrayDisplay($resoult)
	$resoult = _ESsolve($ES_ALGORITHM_SCAN, $tracks, 0, True, $avanceWay, 0, 199)
	_ArrayDisplay($resoult)
EndFunc
Func ____TEST_EJ5()
	Dim $list0 = [10, 98, 100, 126, 46]
	Dim $list1 = [14, 30, 160]
	Dim $list7 = [170]
	Dim $tracks[3][2]
	$tracks[0][0] = 0
	$tracks[0][1] = $list0
	$tracks[1][0] = 1
	$tracks[1][1] = $list1
	$tracks[2][0] = 7
	$tracks[2][1] = $list7
	Dim $avanceWay[2]
	$avanceWay[0] = 1
	$avanceWay[1] = 1

	$resoult = _ESsolve($ES_ALGORITHM_FSCAN, $tracks, 1, True, $avanceWay, 1, 200)
	_ArrayDisplay($resoult)
	$resoult = _ESsolve($ES_ALGORITHM_FLOOK, $tracks, 1, True, $avanceWay, 1, 200)
	_ArrayDisplay($resoult)
	$resoult = _ESsolve($ES_ALGORITHM_SCANN, $tracks, 1, True, $avanceWay, 1, 200, 4)
	_ArrayDisplay($resoult)
	$resoult = _ESsolve($ES_ALGORITHM_LOOKN, $tracks, 1, True, $avanceWay, 1, 200, 4)
	_ArrayDisplay($resoult)
EndFunc
Func ____TEST_EJ6()
	Dim $list1 = [90, 25, 8, 88]
	Dim $tracks[1][2]
	$tracks[0][0] = 0
	$tracks[0][1] = $list1
	Dim $avanceWay[2]
	$avanceWay[0] = 1
	$avanceWay[1] = 1

	$resoult = _ESsolve($ES_ALGORITHM_FCFS, $tracks, 50, True, $avanceWay, 1, 92)
	_ArrayDisplay($resoult)
	$resoult = _ESsolve($ES_ALGORITHM_SSTF, $tracks, 50, True, $avanceWay, 1, 92)
	_ArrayDisplay($resoult)
	$resoult = _ESsolve($ES_ALGORITHM_SCAN, $tracks, 50, True, $avanceWay, 1, 92)
	_ArrayDisplay($resoult)
	$resoult = _ESsolve($ES_ALGORITHM_CSCAN, $tracks, 50, True, $avanceWay, 1, 92)
	_ArrayDisplay($resoult)
	$resoult = _ESsolve($ES_ALGORITHM_SCANN, $tracks, 50, True, $avanceWay, 1, 92, 3)
	_ArrayDisplay($resoult)
EndFunc
Func ____TEST_EJ9()
	Dim $list1 = [45, 390, 230, 100, 23, 415, 233, 22, 50, 60]
	Dim $tracks[1][2]
	$tracks[0][0] = 0
	$tracks[0][1] = $list1
	Dim $avanceWay[2]
	$avanceWay[0] = 1
	$avanceWay[1] = 1

	$resoult = _ESsolve($ES_ALGORITHM_LOOK, $tracks, 300, False, $avanceWay, 1, 512)
	_ArrayDisplay($resoult)
	$resoult = _ESsolve($ES_ALGORITHM_CSCAN, $tracks, 300, False, $avanceWay, 1, 512, 0, False)
	_ArrayDisplay($resoult)
	$resoult = _ESsolve($ES_ALGORITHM_SSTF, $tracks, 300, False, $avanceWay, 1, 512)
	_ArrayDisplay($resoult)
EndFunc
Func ____TEST_EJ10()
	Dim $list1 = [232, 440, 170, 740, 105, 360, 230, 500]
	Dim $tracks[1][2]
	$tracks[0][0] = 0
	$tracks[0][1] = $list1
	Dim $avanceWay[2]
	$avanceWay[0] = 1
	$avanceWay[1] = 1

	$resoult = _ESsolve($ES_ALGORITHM_LOOK, $tracks, 200, True, $avanceWay, 0, 749)
	_ArrayDisplay($resoult)
	$resoult = _ESsolve($ES_ALGORITHM_SCANN, $tracks, 200, True, $avanceWay, 0, 749, 4)
	_ArrayDisplay($resoult)
EndFunc
Func ____TEST_EJ11()
	Dim $list0 = [0, 3, 7, 1]
	Dim $list2 = [14, 2, 6, 4]
	Dim $tracks[2][2]
	$tracks[0][0] = 0
	$tracks[0][1] = $list0
	$tracks[1][0] = 2
	$tracks[1][1] = $list2
	Dim $avanceWay[2]
	$avanceWay[0] = 1
	$avanceWay[1] = 1

	$resoult = _ESsolve($ES_ALGORITHM_SSTF, $tracks, 0, True, $avanceWay, 0, 14)
	_ArrayDisplay($resoult)
	$resoult = _ESsolve($ES_ALGORITHM_FLOOK, $tracks, 0, True, $avanceWay, 0, 14)
	_ArrayDisplay($resoult)
EndFunc
Func ____TEST_EJ12()
	Dim $list0 = [10, 52, 181, 142]
	Dim $list1 = [15, 130, 90, 148]
	Dim $list7 = [60, 5, 172, 12]
	Dim $tracks[3][2]
	$tracks[0][0] = 0
	$tracks[0][1] = $list0
	$tracks[1][0] = 1
	$tracks[1][1] = $list1
	$tracks[2][0] = 7
	$tracks[2][1] = $list7
	Dim $avanceWay[2]
	$avanceWay[0] = 1
	$avanceWay[1] = 1

	$resoult = _ESsolve($ES_ALGORITHM_FLOOK, $tracks, 176, False, $avanceWay, 0, 199)
	_ArrayDisplay($resoult)
	$resoult = _ESsolve($ES_ALGORITHM_LOOKN, $tracks, 176, False, $avanceWay, 0, 199, 3)
	_ArrayDisplay($resoult)
EndFunc
Func ____TEST_EJ13()
	Dim $list0 = [10, 52, 181, 142]
	Dim $list15 = [15, 130]
	Dim $list36 = [90]
	Dim $list38 = [148]
	Dim $list40 = [60]
	Dim $list53 = [5]
	Dim $list60 = [172]
	Dim $list63 = [12]
	Dim $tracks[8][2]
	$tracks[0][0] = 0
	$tracks[0][1] = $list0
	$tracks[1][0] = 15
	$tracks[1][1] = $list15
	$tracks[2][0] = 36
	$tracks[2][1] = $list36
	$tracks[3][0] = 38
	$tracks[3][1] = $list38
	$tracks[4][0] = 40
	$tracks[4][1] = $list40
	$tracks[5][0] = 53
	$tracks[5][1] = $list53
	$tracks[6][0] = 60
	$tracks[6][1] = $list60
	$tracks[7][0] = 63
	$tracks[7][1] = $list63
	Dim $avanceWay[2]
	$avanceWay[0] = 2
	$avanceWay[1] = 0.1

	$resoult = _ESsolve($ES_ALGORITHM_FLOOK, $tracks, 176, False, $avanceWay, 0, 199)
	_ArrayDisplay($resoult)
EndFunc
Func ____TEST_EJ14()
	Dim $list1 = [86, 1470, 913, 1774, 948, 1509, 1022, 1750, 130]
	Dim $tracks[1][2]
	$tracks[0][0] = 0
	$tracks[0][1] = $list1
	Dim $avanceWay[2]
	$avanceWay[0] = 1
	$avanceWay[1] = 1

	$resoult = _ESsolve($ES_ALGORITHM_SCAN, $tracks, 143, True, $avanceWay, 0, 4999)
	_ArrayDisplay($resoult)
	$resoult = _ESsolve($ES_ALGORITHM_CLOOK, $tracks, 143, True, $avanceWay, 0, 4999)
	_ArrayDisplay($resoult)
EndFunc
#EndRegion TESTS
