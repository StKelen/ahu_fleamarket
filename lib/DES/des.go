package DES

import (
	"strconv"
)

func StrEnc(data string, firstKey string, secondKey string, thirdKey string) (encData string) {
	length := len(data)
	var firstKeyBt, secondKeyBt, thirdKeyBt [][64]int
	var firstKeyLength, secondKeyLength, thirdKeyLength int
	firstKeyBt = getKeyBytes(firstKey)
	firstKeyLength = len(firstKeyBt)
	secondKeyBt = getKeyBytes(secondKey)
	secondKeyLength = len(secondKeyBt)
	thirdKeyBt = getKeyBytes(thirdKey)
	thirdKeyLength = len(thirdKeyBt)

	if length > 0 {
		if length < 4 {
			bt := strToBt(data)
			var encByte [64]int
			if firstKey != "" && secondKey != "" && thirdKey != "" {
				tempBt := bt
				for x := 0; x < firstKeyLength; x++ {
					tempBt = enc(tempBt, firstKeyBt[x])
				}
				for y := 0; y < secondKeyLength; y++ {
					tempBt = enc(tempBt, secondKeyBt[y])
				}
				for z := 0; z < thirdKeyLength; z++ {
					tempBt = enc(tempBt, thirdKeyBt[z])
				}
				encByte = tempBt
			} else if firstKey != "" && secondKey != "" {
				tempBt := bt
				for x := 0; x < firstKeyLength; x++ {
					tempBt = enc(tempBt, firstKeyBt[x])
				}
				for y := 0; y < secondKeyLength; y++ {
					tempBt = enc(tempBt, secondKeyBt[y])
				}
				encByte = tempBt
			} else {
				tempBt := bt
				for x := 0; x < firstKeyLength; x++ {
					tempBt = enc(tempBt, firstKeyBt[x])
				}
				encByte = tempBt
			}
			encData = btToHex(encByte)
		} else {
			iterator := length / 4
			remainder := length % 4
			for i := 0; i < iterator; i++ {
				tempData := data[i*4+0 : i*4+4]
				tempByte := strToBt(tempData)
				var encByte [64]int
				if firstKey != "" && secondKey != "" && thirdKey != "" {
					tempBt := tempByte
					for x := 0; x < firstKeyLength; x++ {
						tempBt = enc(tempBt, firstKeyBt[x])
					}
					for y := 0; y < secondKeyLength; y++ {
						tempBt = enc(tempBt, secondKeyBt[y])
					}
					for z := 0; z < thirdKeyLength; z++ {
						tempBt = enc(tempBt, thirdKeyBt[z])
					}
					encByte = tempBt
				} else if firstKey != "" && secondKey != "" {
					tempBt := tempByte
					for x := 0; x < firstKeyLength; x++ {
						tempBt = enc(tempBt, firstKeyBt[x])
					}
					for y := 0; y < secondKeyLength; y++ {
						tempBt = enc(tempBt, secondKeyBt[y])
					}
					encByte = tempBt
				} else {
					tempBt := tempByte
					for x := 0; x < firstKeyLength; x++ {
						tempBt = enc(tempBt, firstKeyBt[x])
					}
					encByte = tempBt
				}
				encData += btToHex(encByte)
			}
			if remainder > 0 {
				remainderData := data[iterator*4+0 : length]
				tempByte := strToBt(remainderData)
				var encByte [64]int
				if firstKey != "" && secondKey != "" && thirdKey != "" {
					tempBt := tempByte
					for x := 0; x < firstKeyLength; x++ {
						tempBt = enc(tempBt, firstKeyBt[x])
					}
					for y := 0; y < secondKeyLength; y++ {
						tempBt = enc(tempBt, secondKeyBt[y])
					}
					for z := 0; z < thirdKeyLength; z++ {
						tempBt = enc(tempBt, thirdKeyBt[z])
					}
					encByte = tempBt
				} else if firstKey != "" && secondKey != "" {
					tempBt := tempByte
					for x := 0; x < firstKeyLength; x++ {
						tempBt = enc(tempBt, firstKeyBt[x])
					}
					for y := 0; y < secondKeyLength; y++ {
						tempBt = enc(tempBt, secondKeyBt[y])
					}
					encByte = tempBt
				} else {
					tempBt := tempByte
					for x := 0; x < firstKeyLength; x++ {
						tempBt = enc(tempBt, firstKeyBt[x])
					}
					encByte = tempBt
				}
				encData += btToHex(encByte)
			}
		}
	}
	return encData
}

func getKeyBytes(key string) [][64]int {
	length := len(key)
	iterator := length / 4
	remainder := length % 4
	var keyBytes [][64]int
	if remainder > 0 {
		keyBytes = make([][64]int, iterator+1)
		keyBytes[iterator] = strToBt(key[length-remainder:])
	} else {
		keyBytes = make([][64]int, iterator)
	}
	for i := 0; i < iterator; i++ {
		keyBytes[i] = strToBt(key[i*4+0 : i*4+4])
	}
	return keyBytes
}

func strToBt(str string) [64]int {
	length := len(str)
	var bt [64]int
	if length < 4 {
		p, q := 0, 0
		for i, char := range str {
			k := byte(char)
			for j := 0; j < 16; j++ {
				pow := 1
				for m := 15; m > j; m-- {
					pow *= 2
				}
				bt[16*i+j] = (int(k) / pow) % 2
			}
		}
		for p = length; p < 4; p++ {
			k := 0
			for q = 0; q < 16; q++ {
				pow := 1
				for m := 15; m > q; m-- {
					pow *= 2
				}
				bt[16*p+q] = (k / pow) % 2
			}
		}
	} else {
		for i, k := range str[0:4] {
			for j := 0; j < 16; j++ {
				pow := 1
				for m := 15; m > j; m-- {
					pow *= 2
				}
				bt[16*i+j] = (int(k) / pow) % 2
			}
		}
	}
	return bt
}

func enc(dataByte [64]int, keyByte [64]int) (finalData [64]int) {
	keys := generateKeys(keyByte)
	ipByte := initPermute(dataByte)
	var ipLeft, ipRight, tempLeft [32]int
	for k := 0; k < 32; k++ {
		ipLeft[k] = ipByte[k]
		ipRight[k] = ipByte[k+32]
	}
	for i := 0; i < 16; i++ {
		for j := 0; j < 32; j++ {
			tempLeft[j] = ipLeft[j]
			ipLeft[j] = ipRight[j]
		}
		var key [48]int
		for m := 0; m < 48; m++ {
			key[m] = keys[i][m]
		}
		tempRight := xor32B(pPermute(sBoxPermute(xor48B(expandPermute(ipRight), key))), tempLeft)
		for n := 0; n < 32; n++ {
			ipRight[n] = tempRight[n]
		}
	}
	for i := 0; i < 32; i++ {
		finalData[i] = ipRight[i]
		finalData[32+i] = ipLeft[i]
	}
	finalData = finalPermute(finalData)
	return finalData
}

func generateKeys(keyByte [64]int) (keys [16][48]int) {
	var key [56]int
	var tempKey [48]int
	loop := [...]int{1, 1, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2, 1}
	for i := 0; i < 7; i++ {
		for j, k := 0, 7; j < 8; j++ {
			key[i*8+j] = keyByte[8*k+i]
			k--
		}
	}
	for i := 0; i < 16; i++ {
		tempLeft, tempRight := 0, 0
		for j := 0; j < loop[i]; j++ {
			tempLeft = key[0]
			tempRight = key[28]
			for k := 0; k < 27; k++ {
				key[k] = key[k+1]
				key[k+28] = key[k+29]
			}
			key[27] = tempLeft
			key[55] = tempRight
		}
		tempKey[0] = key[13]
		tempKey[1] = key[16]
		tempKey[2] = key[10]
		tempKey[3] = key[23]
		tempKey[4] = key[0]
		tempKey[5] = key[4]
		tempKey[6] = key[2]
		tempKey[7] = key[27]
		tempKey[8] = key[14]
		tempKey[9] = key[5]
		tempKey[10] = key[20]
		tempKey[11] = key[9]
		tempKey[12] = key[22]
		tempKey[13] = key[18]
		tempKey[14] = key[11]
		tempKey[15] = key[3]
		tempKey[16] = key[25]
		tempKey[17] = key[7]
		tempKey[18] = key[15]
		tempKey[19] = key[6]
		tempKey[20] = key[26]
		tempKey[21] = key[19]
		tempKey[22] = key[12]
		tempKey[23] = key[1]
		tempKey[24] = key[40]
		tempKey[25] = key[51]
		tempKey[26] = key[30]
		tempKey[27] = key[36]
		tempKey[28] = key[46]
		tempKey[29] = key[54]
		tempKey[30] = key[29]
		tempKey[31] = key[39]
		tempKey[32] = key[50]
		tempKey[33] = key[44]
		tempKey[34] = key[32]
		tempKey[35] = key[47]
		tempKey[36] = key[43]
		tempKey[37] = key[48]
		tempKey[38] = key[38]
		tempKey[39] = key[55]
		tempKey[40] = key[33]
		tempKey[41] = key[52]
		tempKey[42] = key[45]
		tempKey[43] = key[41]
		tempKey[44] = key[49]
		tempKey[45] = key[35]
		tempKey[46] = key[28]
		tempKey[47] = key[31]
		switch i {
		case 0:
			for m := 0; m < 48; m++ {
				keys[0][m] = tempKey[m]
			}
		case 1:
			for m := 0; m < 48; m++ {
				keys[1][m] = tempKey[m]
			}
		case 2:
			for m := 0; m < 48; m++ {
				keys[2][m] = tempKey[m]
			}
		case 3:
			for m := 0; m < 48; m++ {
				keys[3][m] = tempKey[m]
			}
		case 4:
			for m := 0; m < 48; m++ {
				keys[4][m] = tempKey[m]
			}
		case 5:
			for m := 0; m < 48; m++ {
				keys[5][m] = tempKey[m]
			}
		case 6:
			for m := 0; m < 48; m++ {
				keys[6][m] = tempKey[m]
			}
		case 7:
			for m := 0; m < 48; m++ {
				keys[7][m] = tempKey[m]
			}
		case 8:
			for m := 0; m < 48; m++ {
				keys[8][m] = tempKey[m]
			}
		case 9:
			for m := 0; m < 48; m++ {
				keys[9][m] = tempKey[m]
			}
		case 10:
			for m := 0; m < 48; m++ {
				keys[10][m] = tempKey[m]
			}
		case 11:
			for m := 0; m < 48; m++ {
				keys[11][m] = tempKey[m]
			}
		case 12:
			for m := 0; m < 48; m++ {
				keys[12][m] = tempKey[m]
			}
		case 13:
			for m := 0; m < 48; m++ {
				keys[13][m] = tempKey[m]
			}
		case 14:
			for m := 0; m < 48; m++ {
				keys[14][m] = tempKey[m]
			}
		case 15:
			for m := 0; m < 48; m++ {
				keys[15][m] = tempKey[m]
			}
		}
	}
	return keys
}

func initPermute(originData [64]int) (ipByte [64]int) {
	for i, m, n := 0, 1, 0; i < 4; i++ {
		for j, k := 7, 0; j >= 0; j-- {
			ipByte[i*8+k] = originData[j*8+m]
			ipByte[i*8+k+32] = originData[j*8+n]
			k++
		}
		m += 2
		n += 2
	}
	return ipByte
}

func expandPermute(rightData [32]int) (epByte [48]int) {
	for i := 0; i < 8; i++ {
		if i == 0 {
			epByte[i*6+0] = rightData[31]
		} else {
			epByte[i*6+0] = rightData[i*4-1]
		}
		epByte[i*6+1] = rightData[i*4+0]
		epByte[i*6+2] = rightData[i*4+1]
		epByte[i*6+3] = rightData[i*4+2]
		epByte[i*6+4] = rightData[i*4+3]
		if i == 7 {
			epByte[i*6+5] = rightData[0]
		} else {
			epByte[i*6+5] = rightData[i*4+4]
		}
	}
	return epByte
}

func sBoxPermute(expandByte [48]int) (sBoxByte [32]int) {
	var s1, s2, s3, s4, s5, s6, s7, s8 [4][16]int
	var bin string

	/* Table - s1 */
	s1 = [4][16]int{
		{14, 4, 13, 1, 2, 15, 11, 8, 3, 10, 6, 12, 5, 9, 0, 7},
		{0, 15, 7, 4, 14, 2, 13, 1, 10, 6, 12, 11, 9, 5, 3, 8},
		{4, 1, 14, 8, 13, 6, 2, 11, 15, 12, 9, 7, 3, 10, 5, 0},
		{15, 12, 8, 2, 4, 9, 1, 7, 5, 11, 3, 14, 10, 0, 6, 13}}
	/* Table - s2 */
	s2 = [4][16]int{
		{15, 1, 8, 14, 6, 11, 3, 4, 9, 7, 2, 13, 12, 0, 5, 10},
		{3, 13, 4, 7, 15, 2, 8, 14, 12, 0, 1, 10, 6, 9, 11, 5},
		{0, 14, 7, 11, 10, 4, 13, 1, 5, 8, 12, 6, 9, 3, 2, 15},
		{13, 8, 10, 1, 3, 15, 4, 2, 11, 6, 7, 12, 0, 5, 14, 9}}
	/* Table - s3 */
	s3 = [4][16]int{
		{10, 0, 9, 14, 6, 3, 15, 5, 1, 13, 12, 7, 11, 4, 2, 8},
		{13, 7, 0, 9, 3, 4, 6, 10, 2, 8, 5, 14, 12, 11, 15, 1},
		{13, 6, 4, 9, 8, 15, 3, 0, 11, 1, 2, 12, 5, 10, 14, 7},
		{1, 10, 13, 0, 6, 9, 8, 7, 4, 15, 14, 3, 11, 5, 2, 12}}
	/* Table - s4 */
	s4 = [4][16]int{
		{7, 13, 14, 3, 0, 6, 9, 10, 1, 2, 8, 5, 11, 12, 4, 15},
		{13, 8, 11, 5, 6, 15, 0, 3, 4, 7, 2, 12, 1, 10, 14, 9},
		{10, 6, 9, 0, 12, 11, 7, 13, 15, 1, 3, 14, 5, 2, 8, 4},
		{3, 15, 0, 6, 10, 1, 13, 8, 9, 4, 5, 11, 12, 7, 2, 14}}
	/* Table - s5 */
	s5 = [4][16]int{
		{2, 12, 4, 1, 7, 10, 11, 6, 8, 5, 3, 15, 13, 0, 14, 9},
		{14, 11, 2, 12, 4, 7, 13, 1, 5, 0, 15, 10, 3, 9, 8, 6},
		{4, 2, 1, 11, 10, 13, 7, 8, 15, 9, 12, 5, 6, 3, 0, 14},
		{11, 8, 12, 7, 1, 14, 2, 13, 6, 15, 0, 9, 10, 4, 5, 3}}
	/* Table - s6 */
	s6 = [4][16]int{
		{12, 1, 10, 15, 9, 2, 6, 8, 0, 13, 3, 4, 14, 7, 5, 11},
		{10, 15, 4, 2, 7, 12, 9, 5, 6, 1, 13, 14, 0, 11, 3, 8},
		{9, 14, 15, 5, 2, 8, 12, 3, 7, 0, 4, 10, 1, 13, 11, 6},
		{4, 3, 2, 12, 9, 5, 15, 10, 11, 14, 1, 7, 6, 0, 8, 13}}
	/* Table - s7 */
	s7 = [4][16]int{
		{4, 11, 2, 14, 15, 0, 8, 13, 3, 12, 9, 7, 5, 10, 6, 1},
		{13, 0, 11, 7, 4, 9, 1, 10, 14, 3, 5, 12, 2, 15, 8, 6},
		{1, 4, 11, 13, 12, 3, 7, 14, 10, 15, 6, 8, 0, 5, 9, 2},
		{6, 11, 13, 8, 1, 4, 10, 7, 9, 5, 0, 15, 14, 2, 3, 12}}
	/* Table - s8 */
	s8 = [4][16]int{
		{13, 2, 8, 4, 6, 15, 11, 1, 10, 9, 3, 14, 5, 0, 12, 7},
		{1, 15, 13, 8, 10, 3, 7, 4, 12, 5, 6, 11, 0, 14, 9, 2},
		{7, 11, 4, 1, 9, 12, 14, 2, 0, 6, 10, 13, 15, 3, 5, 8},
		{2, 1, 14, 7, 4, 10, 8, 13, 15, 12, 9, 0, 3, 5, 6, 11}}

	for m := 0; m < 8; m++ {
		i, j := 0, 0
		i = expandByte[m*6+0]*2 + expandByte[m*6+5]
		j = expandByte[m*6+1]*2*2*2 +
			expandByte[m*6+2]*2*2 +
			expandByte[m*6+3]*2 +
			expandByte[m*6+4]
		switch m {
		case 0:
			bin = getBoxBinary(s1[i][j])
		case 1:
			bin = getBoxBinary(s2[i][j])
		case 2:
			bin = getBoxBinary(s3[i][j])
		case 3:
			bin = getBoxBinary(s4[i][j])
		case 4:
			bin = getBoxBinary(s5[i][j])
		case 5:
			bin = getBoxBinary(s6[i][j])
		case 6:
			bin = getBoxBinary(s7[i][j])
		case 7:
			bin = getBoxBinary(s8[i][j])
		}
		first, _ := strconv.Atoi(bin[0:1])
		second, _ := strconv.Atoi(bin[1:2])
		third, _ := strconv.Atoi(bin[2:3])
		fourth, _ := strconv.Atoi(bin[3:4])
		sBoxByte[m*4+0] = first
		sBoxByte[m*4+1] = second
		sBoxByte[m*4+2] = third
		sBoxByte[m*4+3] = fourth
	}
	return sBoxByte
}

func pPermute(sBoxByte [32]int) (pBoxPermute [32]int) {
	pBoxPermute[0] = sBoxByte[15]
	pBoxPermute[1] = sBoxByte[6]
	pBoxPermute[2] = sBoxByte[19]
	pBoxPermute[3] = sBoxByte[20]
	pBoxPermute[4] = sBoxByte[28]
	pBoxPermute[5] = sBoxByte[11]
	pBoxPermute[6] = sBoxByte[27]
	pBoxPermute[7] = sBoxByte[16]
	pBoxPermute[8] = sBoxByte[0]
	pBoxPermute[9] = sBoxByte[14]
	pBoxPermute[10] = sBoxByte[22]
	pBoxPermute[11] = sBoxByte[25]
	pBoxPermute[12] = sBoxByte[4]
	pBoxPermute[13] = sBoxByte[17]
	pBoxPermute[14] = sBoxByte[30]
	pBoxPermute[15] = sBoxByte[9]
	pBoxPermute[16] = sBoxByte[1]
	pBoxPermute[17] = sBoxByte[7]
	pBoxPermute[18] = sBoxByte[23]
	pBoxPermute[19] = sBoxByte[13]
	pBoxPermute[20] = sBoxByte[31]
	pBoxPermute[21] = sBoxByte[26]
	pBoxPermute[22] = sBoxByte[2]
	pBoxPermute[23] = sBoxByte[8]
	pBoxPermute[24] = sBoxByte[18]
	pBoxPermute[25] = sBoxByte[12]
	pBoxPermute[26] = sBoxByte[29]
	pBoxPermute[27] = sBoxByte[5]
	pBoxPermute[28] = sBoxByte[21]
	pBoxPermute[29] = sBoxByte[10]
	pBoxPermute[30] = sBoxByte[3]
	pBoxPermute[31] = sBoxByte[24]
	return pBoxPermute
}

func finalPermute(endByte [64]int) (fpByte [64]int) {
	fpByte[0] = endByte[39]
	fpByte[1] = endByte[7]
	fpByte[2] = endByte[47]
	fpByte[3] = endByte[15]
	fpByte[4] = endByte[55]
	fpByte[5] = endByte[23]
	fpByte[6] = endByte[63]
	fpByte[7] = endByte[31]
	fpByte[8] = endByte[38]
	fpByte[9] = endByte[6]
	fpByte[10] = endByte[46]
	fpByte[11] = endByte[14]
	fpByte[12] = endByte[54]
	fpByte[13] = endByte[22]
	fpByte[14] = endByte[62]
	fpByte[15] = endByte[30]
	fpByte[16] = endByte[37]
	fpByte[17] = endByte[5]
	fpByte[18] = endByte[45]
	fpByte[19] = endByte[13]
	fpByte[20] = endByte[53]
	fpByte[21] = endByte[21]
	fpByte[22] = endByte[61]
	fpByte[23] = endByte[29]
	fpByte[24] = endByte[36]
	fpByte[25] = endByte[4]
	fpByte[26] = endByte[44]
	fpByte[27] = endByte[12]
	fpByte[28] = endByte[52]
	fpByte[29] = endByte[20]
	fpByte[30] = endByte[60]
	fpByte[31] = endByte[28]
	fpByte[32] = endByte[35]
	fpByte[33] = endByte[3]
	fpByte[34] = endByte[43]
	fpByte[35] = endByte[11]
	fpByte[36] = endByte[51]
	fpByte[37] = endByte[19]
	fpByte[38] = endByte[59]
	fpByte[39] = endByte[27]
	fpByte[40] = endByte[34]
	fpByte[41] = endByte[2]
	fpByte[42] = endByte[42]
	fpByte[43] = endByte[10]
	fpByte[44] = endByte[50]
	fpByte[45] = endByte[18]
	fpByte[46] = endByte[58]
	fpByte[47] = endByte[26]
	fpByte[48] = endByte[33]
	fpByte[49] = endByte[1]
	fpByte[50] = endByte[41]
	fpByte[51] = endByte[9]
	fpByte[52] = endByte[49]
	fpByte[53] = endByte[17]
	fpByte[54] = endByte[57]
	fpByte[55] = endByte[25]
	fpByte[56] = endByte[32]
	fpByte[57] = endByte[0]
	fpByte[58] = endByte[40]
	fpByte[59] = endByte[8]
	fpByte[60] = endByte[48]
	fpByte[61] = endByte[16]
	fpByte[62] = endByte[56]
	fpByte[63] = endByte[24]
	return fpByte
}

func xor48B(byteOne [48]int, byteTwo [48]int) (xorByte [48]int) {
	for i := 0; i < 48; i++ {
		xorByte[i] = byteOne[i] ^ byteTwo[i]
	}
	return xorByte
}

func xor32B(byteOne [32]int, byteTwo [32]int) (xorByte [32]int) {
	for i := 0; i < 32; i++ {
		xorByte[i] = byteOne[i] ^ byteTwo[i]
	}
	return xorByte
}

func getBoxBinary(i int) (bin string) {
	switch i {
	case 0:
		bin = "0000"
	case 1:
		bin = "0001"
	case 2:
		bin = "0010"
	case 3:
		bin = "0011"
	case 4:
		bin = "0100"
	case 5:
		bin = "0101"
	case 6:
		bin = "0110"
	case 7:
		bin = "0111"
	case 8:
		bin = "1000"
	case 9:
		bin = "1001"
	case 10:
		bin = "1010"
	case 11:
		bin = "1011"
	case 12:
		bin = "1100"
	case 13:
		bin = "1101"
	case 14:
		bin = "1110"
	case 15:
		bin = "1111"
	}
	return bin
}

func btToHex(byteData [64]int) (hex string) {
	for i := 0; i < 16; i++ {
		bt := ""
		for j := 0; j < 4; j++ {
			strSlice := strconv.Itoa(byteData[i*4+j])
			bt += strSlice
		}
		hex += bt4ToHex(bt)
	}
	return hex
}

func bt4ToHex(strSlice string) (hex string) {
	switch strSlice {
	case "0000":
		hex = "0"
	case "0001":
		hex = "1"
	case "0010":
		hex = "2"
	case "0011":
		hex = "3"
	case "0100":
		hex = "4"
	case "0101":
		hex = "5"
	case "0110":
		hex = "6"
	case "0111":
		hex = "7"
	case "1000":
		hex = "8"
	case "1001":
		hex = "9"
	case "1010":
		hex = "A"
	case "1011":
		hex = "B"
	case "1100":
		hex = "C"
	case "1101":
		hex = "D"
	case "1110":
		hex = "E"
	case "1111":
		hex = "F"
	}
	return hex
}
