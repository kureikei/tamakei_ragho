#ifndef __MOD_TAMAKEISD
#define __MOD_TAMAKEISD
;
;
#module "_tamakeisd"

	;	�쉹�����E�v��������� SD �㔼�g�R���{�f��
	;	HSP3�p�X�N���v�g�T���v��( https://hsp.tv/ )
	;	(���ۂ̉摜�f�ރf�[�^��png�t�H���_�ɓ����Ă��܂�)
	;
	;	��� �d�i�v���������j(C) Pronama LLC
	;	�쉹����� (C) �I�K���R�E�T�N(�`�[���O���O��)/HSPTV!/onion software
	;	�����̃X�N���v�g�y�уT���v���f�[�^�́A�K�C�h���C���̂��Ǝ��R�ɂ��g�������܂�
	;	https://github.com/onitama/tamakei_ragho
	;

#deffunc sdchr_load int _p1, int _p2, int _p3

	;	SD�L�����̏���
	;	sdchr_load p1, p2, p3
	;
	;	p1(0) : �L����ID(0=�d/1=�쉹/2=�t�B�l�X/3=��R�)
	;	p2(0) : ����(0=�E/1=��)
	;	p3(0) : �T�C�Y%(0=100%)
	;
	fflag=0
	fsx=640:fsy=1024		; �f�ރT�C�Y
	fox=512:foy=256			; �ǉ��\��T�C�Y
	fpx=384:fpy=128:fpx2=fpx/2	; �A�j���p�[�c�T�C�Y
	fofs_eye=fpy*4
	fofs_mouth=fpy*7
	frate=_p3
	if _p3<=0 : frate=100
	;
	chrid=_p1
	if chrid<0|chrid>3 : return

	bname="ketafiti"
	name=strmid(bname,chrid*2,2)
	if _p2=0 {
		name+="r"
		chrflip(chrid)=1
	} else {
		name+="l"
		chrflip(chrid)=0
	}
	;
	fid_up=3+chrid*2
	fid_opt=4+chrid*2
	fname="up_"+name+".png"
	celload fname,fid_up
	fname="face_"+name+".png"
	celload fname,fid_opt
	celdiv fid_opt, fox,foy
	;
	fflag=1
	return

#deffunc sdchr_put int _p1, int _p2, int _p3, int _p4

	;	SD�L�����̕\��(�p�[�c�ω�����)
	;	(���炩����sdchr_load�ŃL�����̏��������Ă����K�v������܂�)
	;	(pos�Ŏw�肳�ꂽ�J�����g�|�W�V��������\�����܂�)
	;	sdchr_put p1,p2,p3,p4
	;
	;	p1(0) : �L����ID(0=�d/1=�쉹/2=�t�B�l�X/3=��R�)
	;	p2(0) : ��(0=����/1=�߂���/2=�{��/3=����)
	;	p3(0) : ��(0=����/1=����/2=����)
	;	p4(0) : ��(0=����/1=�J��)
	;
	if fflag=0 : return

	chrid=_p1
	gosub *sdchr_prepare

	xx=ginfo_cx:yy=ginfo_cy
	gmode 2,fsx,fsy,255
	pos xx,yy
	sx=fsx*frate/100:sy=fsy*frate/100
	gzoom sx,sy,fid_up,0,0,,,1

	gmode 2,fpx,fpy,255
	sx=fpx*frate/100:sy=fpy*frate/100
	x=axdata(2)*frate/100:y=axdata(3)*frate/100
	pos xx+x,yy+y:gzoom sx,sy,fid_up,fsx,_p2*fpy,,,1
	x=axdata(4)*frate/100:y=axdata(5)*frate/100
	pos xx+x,yy+y:gzoom sx,sy,fid_up,fsx,_p3*fpy+fofs_eye,,,1
	sx=fpx2*frate/100
	x=axdata(6)*frate/100:y=axdata(7)*frate/100
	pos xx+x,yy+y:gzoom sx,sy,fid_up,fsx+_p4*fpx2,fofs_mouth,fpx2,fpy,1

	return


#deffunc sdchr_putex int _p1, int _p2

	;	SD�L�����̕\��(�\���)
	;	(���炩����sdchr_load�ŃL�����̏��������Ă����K�v������܂�)
	;	(pos�Ŏw�肳�ꂽ�J�����g�|�W�V��������\�����܂�)
	;	sdchr_putex p1
	;
	;	p1(0) : �L����ID(0=�d/1=�쉹/2=�t�B�l�X/3=��R�)
	;	p2(0) : �\��(1=����/2=�ǂ�/3=�ۖ�/4=�ɂ�����/5=�{��/6=������/7=���Ɩ�)
	;
	if fflag=0 : return

	chrid=_p1
	gosub *sdchr_prepare

	xx=ginfo_cx:yy=ginfo_cy
	gmode 2,fsx,fsy,255
	pos xx,yy
	sx=fsx*frate/100:sy=fsy*frate/100
	gzoom sx,sy,fid_up,0,0,,,1

	sx=fox*frate/100:sy=foy*frate/100
	x=axdata(0)*frate/100:y=axdata(1)*frate/100
	pos xx+x,yy+y:gzoom sx,sy,fid_opt,(_p2&1)*fox,(_p2/2)*foy,fox,foy,1
	return


*sdchr_prepare
	fid_up=3+chrid*2
	fid_opt=4+chrid*2

	chrss=chrid*2+chrflip(chrid)
	if chrss=0 : axdata=64,386,90,331,90,419,183,536	;kel
	if chrss=1 : axdata=64,386,169,334,170,421,261,540	;ker
	if chrss=2 : axdata=64,384,116,332,115,427,207,544	;tal
	if chrss=3 : axdata=64,384,129,332,132,432,222,544	;tar
	if chrss=4 : axdata=64,384,83,333,88,421,176,532	;fil
	if chrss=5 : axdata=64,384,198,326,196,425,292,533	;fir
	if chrss=6 : axdata=64,384,98,363,101,448,197,555	;til
	if chrss=7 : axdata=64,384,173,363,160,450,262,555	;tir
	return


#global
#endif

