#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <locale.h>
#include <unistd.h>
#include <string.h>

typedef struct Menu {		//��������� ������������ ��� ��������
							//����������������� ����� � ������ ������
	char menu_choice[0];	//�������� ����
	int menu_switch;

} mnc;

void mainmenu();			//������ ���������� �������
void clearscreen();
void wrongchoice();
void quit();
void rules(mnc *rls);
void back2menu(mnc *bck2mn);
void newgame(mnc *nwgm);
void choosebets(int *money, int *bet, mnc *chsbts);
void confirm();
char getcard(int *getrandom);
int sumcards(char *hand, int quantity);
void dealing(char *gamer, int quantity, int *getrandom);
void getstatus(char *player, int quantity);
void drawning(mnc *drwng, char *player, char *dealer, int *rndm, int *money, int *bet);
void dealerturn(int p_sum, char *dealer, int *rndm, int *money, int *bet);
void conflictBJ(mnc *cnflct, int *money, int *bet, char *dealer);
void showresults(mnc *shwrcrds);
void writeresult(mnc *wrtrcrd, int *money);
void writefile(mnc *wrtfl, int *money);
void getresultline(char *line, int *money, int position);

int main(int argc, char *argv[]) {		//������� �������, ����������� ����

	setlocale(LC_ALL, "Rus");	//������� ��� ����������� ��������� � Dev-Cpp

	mainmenu();					//��������� ������� ����

return 0;
}


void mainmenu() {		//������� �������� ���� 

	clearscreen();		//������� ������� ����� ������� ����

		printf("\n	����������� ��� � ���� BlackJack! \n");
		printf("		������� ����\n");
		printf("		1. ����� ����\n");
		printf("		2. ������� ����\n");
		printf("		3. ����������\n");
		printf("		4. ����� �� ����\n");

	mnc MnMn;			//��������� ��������� ��� �������� ����������������� �����

		do {			//����������� ����, ���� �� ���������� �� ����������� �����
						//������������� �� ���� � ������ �����
			MnMn.menu_switch = 0;

				printf("\n	������� ����� ��� �����������: ");
				scanf("%s", MnMn.menu_choice);

					switch (atoi(MnMn.menu_choice)) {
						case 1:
							newgame(&MnMn);				//�������� ����� ����
							break;
						case 2:
							rules(&MnMn);				//���������� ������� ����
							break;
						case 3:
							showresults(&MnMn);			//�������� ������ � ���������
							back2menu(&MnMn);
							break;
						case 4:
							quit();						//������ ����� �� ���� � �������
							break;
						default:
							MnMn.menu_switch = 1;
							wrongchoice();				//�������������� � �������� �����
							break;
					}

		} while(MnMn.menu_switch);

}

void clearscreen() {	//������� ������� ������� �� �������

	system("cls");	//��� ������ �� ����� �������� �� "cls"

}

void wrongchoice() {	//������� �������������� � ������������ �����
						//���� ���������, ��� ������� ������� ��� �����������
	printf("	������� ���������� �����! �������� 1, 2, 3 � �.�... \n");

}

void quit(){			//������� ������ �� ����

	clearscreen();			//����� ������� ������� �� ����� �������
	printf("\n �����..\n\n");
	sleep(1);

exit(0);					//��������� ������� �� ����������
}

void rules(mnc *rls) {	//�������, ����������� ������� ����

	clearscreen();		//������� ������� ����� ������� ������

		printf("\n 			 ������� ����: \n");
		printf("   ����� �������� ���� ������ ���������� ������� ������, �� ����������� \n");
		printf(" ��� ������� �������. ��������� ������� ������ ����� ���� - 100$.  \n");
		printf(" ����� �������� ������ ����� � ����� �������� �� ��� �����, ������ ����� \n");
		printf(" ����� ������ ���� ����� � ���� ������.\n\n");

		printf("   ����� ������� ����� ����� ����� ��� ��������� ����, � ����� ������ ������ \n");
		printf(" ��� ������. ������ ������ - �������� ������, ������ ����� ������, ��� �  \n");
		printf(" ����, �� �� ����� 21-�� ����. ������ �������� ������ ��������� ������.\n\n");

		printf("   ���� ����� � ����� ������� ���������� ���������� �����, �� ��� ��������� \n");
		printf(" ��� ����� �������. ����� ����� ������� ������ �����, ��� � ������ ��� ������, \n");
		printf(" ��� 21 ����, �� �� ����������� ���� ������. ���� �� ������� ����� �������� \n");
		printf(" BkackJack (21 ����), �� �� �������� 1.5 ����� ������, ������ ���� ��������\n");
		printf(" ����� ������ �� 10, V, Q, K, A. ����� ����� ����� ������� ���� ������, ���� \n");
		printf(" ������ ��� ������. ���� ����� �� �������� BlackJack, �� ����� ���������� 1.5 \n");
		printf(" ����� ������, ���� ������ ���� ������.\n\n");

		printf("			 �������� ����: \n");
		printf("   ��������� ���� � ������� ����� �� ��������� ��������. ����� � ������ ����\n");
		printf(" �� ������ �����. ��� ���� ���� ���� ��� ����������, ������ ����� �������� \n");
		printf(" �������� ������ � ������ ������.\n");
		printf("   ������ ������ ���� ����������, ��������� ������� �� �����������.\n ");

	back2menu(rls);	//������� �������� � ������� ���� ����

}

void back2menu(mnc *bck2mn) {	//������� �������� � ������� ����

	do {		//��������� � ��������������� ����

		bck2mn->menu_switch = 0;
			
			printf("\n	1. ����� � ������� ����: ");
			printf("\n	������� ����� ��� �����������: ");
			scanf("%s", bck2mn->menu_choice);
				
				if (atoi(bck2mn->menu_choice) == 1) {

					mainmenu(&bck2mn);		//���� ����� 1, �� ������������ � ����

				} else {

					bck2mn->menu_switch = 1;	//����� ���������� ���� ��������
					wrongchoice();
					
				}

	} while (bck2mn->menu_switch);

}

void newgame(mnc *nwgm){	//������� ����� ����. ��������� ������ � ������� �����

	clearscreen();

	int money = 100;		//��������� ������� ������
	int bet = 0;			//������ ������
	int getrandom = 1;		//����� ��� ��������� ��������� ����
	int p_sum = 0;			//����� ����� �������
	int quantity;
	char *player = NULL;			//���� ������
	char *dealer = NULL;			//���� ������

		printf("\n 			��� ��������� ������� - 100$\n");
		printf("	�������� ������ � ������������ �������� ��� ����� ������!\n\n");

	while (money > 0 || money >= 1000000) {

		choosebets(&money, &bet, nwgm);		//����������� ������ ������
		clearscreen();						//�������� ���� ����� �������� ������

			player = (char*)calloc(8, sizeof(char));		 //�������������� ������ ����
			dealer = (char*)calloc(8, sizeof(char));		 //���� �������

		printf("\n	������� ���� ��������! ���� ������ %d$\n", bet);
		sleep(1);

			for (quantity = 0; quantity < 2; quantity++) {					//��������� ������� ���� ����

				dealing(dealer, quantity, &getrandom);		//������� ����� ������
				dealing(player, quantity, &getrandom);		//������� ����� ������

			}

		printf("\n	����� � ���� ������: %c\n", *dealer);
		printf("	����� � ����� ����: ");

			getstatus(player, quantity);				//�������� ��������� ���� �������
			p_sum = sumcards(player, quantity);		//��������� ����� ����� � ���� ������

		printf("\n	������� �����: %d\n", p_sum);	//���� ������ ����� �������

			if (p_sum == 21 && (*dealer == 'T'			//�������� � ����� �����������
			|| *dealer == 'V' || *dealer == 'Q'			//���� �������� ������, ���� �������
			|| *dealer == 'K' || *dealer == 'A')) {		//�� 1.5 ������

				conflictBJ(nwgm, &money, &bet, dealer);

			} else if (p_sum == 21) {						//�������� � ��� �� �������

				money = money + (int)(1.5 * bet);					//����������� � ������� ������
				printf("\n	�� ��������! BlackJack �� �������!\n");
				printf("	��� ������� ������� ���������� %d$\n", money);

			} else {										//���� ��� �� ������� ���, �������� �����
															//��� ������ ��� ������ � ���������� ����
				drawning(nwgm, player, dealer, &getrandom, &money, &bet);

			}
			
				sleep(1);			//��������� �����, ����� ����� ��� �������� �����

			while (money > 0) {		//���� � ������ ���� ������, ���������� ������� �����

				printf("\n	1. ������� �����\n ");
				printf("	2. ��������� ����\n");
				printf("	������� ����� ��� �����������: ");
				scanf("%s", nwgm->menu_choice);

					if (atoi(nwgm->menu_choice) == 1) {		//�������� �����
															//���� ����� ��������, ������� �����
						clearscreen();
						printf("\n\n	��� ������� ������� ���������� %d$\n", money);
						break;
					
					} else if (atoi(nwgm->menu_choice) == 2) {

						writeresult(nwgm, &money);			//���� ���, ���������� ������� ������ �������
						break;				//�� ���� ����� ����� �� ���� ��� ������ �������

					} else {

						wrongchoice();

					}

			}

			if (money <= 0) {			//������������ � ����, ���� ������ �����������

				printf("\n	���� ��������. �� ��������� ��� ���� ������");
				back2menu(nwgm);

			} else if (money >= 1000000) {
				
				printf("\n	�����������! �� �������� �������!\n");
				printf("	����� ������ �� ����� ������ � ����");
				sleep(5);
				writeresult(nwgm, &money);
			}
			
		free(player);
		free(dealer);
			
	}

}

void choosebets(int *money, int *bet, mnc *chsbts) { //������� �������� ������

	do {					//����������� � ������ ������
		
		chsbts->menu_switch = 0;
		printf("	������� ���� ������: ");
		scanf("%s", chsbts->menu_choice);

			if (atoi(chsbts->menu_choice) == 0) {			//��������� ������������ �����

				printf("	������� ���������� ����� ������ ����! \n\n");

			} else if (atoi(chsbts->menu_choice) > *money) {	//��������� �������� ������

				printf("	������������ ����� ��� ������! \n\n");

			} else {				//������ ������������� ��������� ������

				printf("\n	�� �������? \n");
				confirm();
				*bet = atoi(chsbts->menu_choice);
				scanf("%s", chsbts->menu_choice);	//��� �� ��������� ������������ �����

					if (atoi(chsbts->menu_choice) == 1) {

						*money = *money - *bet;		//�� ����� ���� ������ ������ �� ��������
						chsbts->menu_switch = 0;
						
					} else if (atoi(chsbts->menu_choice) == 2) {
						
						puts(" ");
						continue;

					} else {					//����������� ������ �� �����, ���� �����

						chsbts->menu_switch = 1;
						wrongchoice();
						puts(" ");
						
					}
					
			}

	} while (chsbts->menu_switch);

}

void confirm() {			//������� ������� �� ������������� ������

	printf("	1. �� \n");
	printf("	2. ��� \n");
	printf("	������� ����� ��� �����������: ");

}

char getcard(int *getrandom) {	//������� ��������� ��������� ����

	srand(time(NULL));			//���� ����������

		int num = 13;
		int a = 0;
		int n;			//����� ������� ����. � �������� �������
		char cards[13] = {'2', '3', '4', '5', '6', '7', '8', '9', 'T', 'V', 'Q', 'K', 'A'};

			for (n = 0; n < *getrandom; n++) {	//���������� ����� �� ��������� ���������

				a = 0 + rand() %num;

			}

return cards[a];		//���������� ��������� �����
}

int sumcards(char *hand, int quantity) {	//�������, ��������� ���� � ����

	int i;
	int score = 0;

		for (i = 0; i < quantity; i++) {	//��������� ���������� ���� � ����

			if (*(hand + i) == ('T') || *(hand + i) == ('V')	//��������� ������ �����
			|| *(hand + i) == ('Q') || *(hand + i) == ('K')) {	//� ������� ����

				score = score + 10;

			} else if (*(hand + i) == ('2') || *(hand + i) == ('3')
					|| *(hand + i) == ('4') || *(hand + i) == ('5')
					|| *(hand + i) == ('6') || *(hand + i) == ('7')
					|| *(hand + i) == ('8') || *(hand + i) == ('9')) {

				score = score + *(hand + i) - '0';

			}

		}

		for (i = 0; i < quantity; i++) {	//��� ���� ��������� ��������

			if (*(hand + i) == 'A') {		//�������� ��������� ������ �����

				if (score > 10) {			//��������� ��������� ���� � ����������

					score = score + 1;

				} else						//1 ��� 11, ������ ����� ����� ��������

					score = score + 11;

			}

		}

return score;
}

void dealing(char *gamer, int quantity, int *getrandom) {	//������� ������� ����

	//gamer = (char*)realloc(gamer, (quantity + 1));//��������� ���� ������ ��� ����� �����
	*(gamer +quantity) = getcard(getrandom);	//������� �����
	*getrandom = *getrandom + 1;			//���������� ��������� �����

}

void getstatus(char *gamer, int quantity) {	//������� ���������� ��������� ����

	int i;

		for (i = 0; i < quantity; i++) {	//������ ���������� �� ����� �����

			printf("%c ", *(gamer + i));

		}

}

void drawning(mnc *drwng, char *player, char *dealer, int *rndm, int *money, int *bet) {
									//������� ������ ���� 
	int np = 0;
	int p_sum = sumcards(player, np + 2); 	//���������� ���� ������
	
		do {
			
			drwng->menu_switch = 1;
			printf("\n	����� ��� �����?\n");	//����������� ����� ��� ����� 
			confirm();							//� ��������� �����
			scanf("%s", drwng->menu_choice);

				if (atoi(drwng->menu_choice) == 1) {	
						
					dealing(player, np + 2, rndm);			//����� ���� ����� 
					printf("\n	����� � ����� ����: ");		//������� ���������� ����
					getstatus(player, np + 3);				//���������� ����� ����� ���� �� ���������
					np++;									//���� �� ������� ������ 21
					p_sum = sumcards(player, np + 3);
					printf("\n	������� �����: %d\n", p_sum);
					
				} else if (atoi(drwng->menu_choice) == 2) {		//���� ����� ����������, ������ 
																//��� ������. �� �������� �����.
					clearscreen();								//������� �����
					
					printf("\n	����� � ����� ����: ");			//������� ���������� �� ������
					getstatus(player, np + 3);
					printf("\n	������� �����: %d\n", sumcards(player, np + 3));
					printf("	���� ������: %d$\n", *bet);
					printf("	������� �������: %d$\n\n", *money);
					sleep(1);
					printf("	������ ����� �������� �����.. \n\n");
						
					sleep(2);
					dealerturn(p_sum, dealer, rndm, money, bet);		//�������� ��� ������
					drwng->menu_switch = 0;
					
				} else wrongchoice();

				if (p_sum > 21) {					//��������� ��������, ����� � ������ �������
													//���� �� ������ BJ
					printf("	� ��� �������, �� ��������� ���� ������\n");
					break;
					
				} else if (p_sum == 21) {
					
					printf("	� ��� ���������� �����!\n\n");	//����� ������ BJ, �������� ���
					printf("	������ ����� �������� �����.. \n\n");
					sleep(1);
					dealerturn(p_sum, dealer, rndm, money, bet);
					drwng->menu_switch = 0;
				}
				
		} while (drwng->menu_switch);
	
}

void dealerturn(int p_sum, char *dealer, int *rndm, int *money, int *bet) { //������� ���� ������
	
	int n;
	int d_sum;
	
		do { 

			d_sum = sumcards(dealer, n + 2);	//������� ������� ����� ������

				if (d_sum < 17) {				//����� ������ ����� ����� � ����������
												//�����, ���� �� ������� 17 ����� � �����
					dealing(dealer, n + 2, rndm);	
					n++;
									
				} else break;
						
		} while (d_sum <= 17);			//����� ����� ������ ����� ������� ��������

		if (d_sum > 21) {							//���� ������� � ������
							
			printf("	����� � ���� ������: ");	//���������� ����� ������ � ����
			getstatus(dealer, n + 2);				//����������� � ������� 
			printf("\n	������� �����: %d\n", d_sum);	//� ����������� �������
			printf("\n	� ������ �������!\n");
			printf("	�� �������� � ����������: %d$\n", 2 * (*bet));
			*money = *money + 2 * (*bet);
							
		} else if (d_sum == p_sum) {
							
			printf("	����� � ���� ������: ");	//���� �����, �� ����������
			getstatus(dealer, n + 2);				//������ ������
			printf("\n	������� �����: %d\n", d_sum);
			printf("	�����! �� ������� ���� ������\n");			
			*money = *money + *bet;
						
		} else if (d_sum > p_sum) {
							
			printf("	����� � ���� ������: ");		//���� � ������ ����� ������
			getstatus(dealer, n + 2);					//�� �� ���������� ������
			printf("\n	������� �����: %d\n", d_sum);	//������
			printf("	������� �����! �� �������� ���� ������\n");				
						
		} else {
							
			printf("	����� � ���� ������: ");	//���� � ������ ����� ������
			getstatus(dealer, n + 2);				//���������� ��������� ������
			printf("\n	������� �����: %d\n", d_sum);
			printf("	�� �������� � ����������: %d$\n", 2 * (*bet));
			*money = *money + 2 * (*bet);
						
		}	
	
}

void conflictBJ(mnc *cnflct, int *money, int *bet, char *dealer) {	//������� ����������� �������� 

	int d_sum;

	printf("\n	������� ��������!  � ������ �������� BlackJack!\n");

		do {

			cnflct->menu_switch = 0;						//���������� ������� ������ ��� 
			printf("	1. ������� ���� ������ \n");		//����������� �������� ������
			printf(" 	2. ������ ��� ������\n");
			printf("	������� ����� ��� �����������: ");
			scanf("%s", cnflct->menu_choice);

				if (atoi(cnflct->menu_choice) == 1) {		//���� ��������, ������� �� ����������

					printf("\n	�� ������� ���� ������\n");
					*money = *money + *bet;
					break;
					
				} else if (atoi(cnflct->menu_choice) == 2) {	//������ ��� ������

					printf("\n\n	����� ��������� ��������� �����..\n");
					sleep(1);
					printf("	����� � ���� ������: ");
					getstatus(dealer, 2);					//��������� ������ ����� ������
					d_sum = sumcards(dealer, 2);

						if (d_sum == 21) {					//���� � ������ BlackJack �� ����������
															
							printf("\n	� ������ ��� BlackJack, �� ���������\n");

						} else {

							printf("\n	� ������ �� ���� BlackJack'�, �� ���������� %d$ \n",
											(int)(1.5 * (*bet)));
							*money = *money + (int)(1.5 * (*bet));	

						}
						
							break;
						
				} else {

					wrongchoice();					//�������� �� ����
					cnflct->menu_switch = 1;

				}

		} while (cnflct->menu_switch);

}

void showresults(mnc *shwrcrds) {	//������� ������ ������������

	clearscreen();		//������� �����

		FILE *file;
		char table[7][23];
		int n = 0;

			file = fopen("results.txt", "a+");	//���� ����� ���, �������. ���� ����, �� ��������� ��� ��������

				while(!feof(file)) {			//������ ���� � ���������� � ������� ������

					fgets(*(table + n), 24, file);	//���� ����� �� ����, �� ������ �� ����������
					n++;

				}

				printf("\n	���������� �������:\n");

		if (table[0][0] != '1') {		//���� ������� ���, �� ��������� �������

			strcpy(table[0], "1. 1000000 - Developer");	//�������-������
			strcpy(table[1], "2.         -          ");
			strcpy(table[2], "3.         -          ");
			strcpy(table[3], "4.         -          ");
			strcpy(table[4], "5.         -          ");
			strcpy(table[5], "6.         -          ");
			strcpy(table[6], "7.         -          ");

				freopen("results.txt", "w", file);		//��������� ���� ��� ������

			for (n = 0; n < 7; n++) {				//���������� ������� � ����� ����

				fprintf(file, "%s\n", *(table + n));	//������� �� �����
				printf("	%s\n", *(table + n));

			}

		} else {		//���� � ����� ���� ������, �� ������� �� �� �����

			freopen("results.txt", "r", file);
			n = 0;

				while(!feof(file)) {

					fgets(*(table + n), 24, file);
					printf("	%s", *(table + n));
					n++;

				}

		}

	fclose(file);		//��������� ����

}

void writeresult(mnc *wrtrcrd, int *money) {	//������� ������ ��������

	clearscreen();

	do {

		wrtrcrd->menu_switch = 0;
		printf("\n	������� �������� ���� ���������?\n");
		confirm();
		scanf("%s", wrtrcrd->menu_choice);

			if (atoi(wrtrcrd->menu_choice) == 1) {

				writefile(wrtrcrd, money);
				break;

			} else if (atoi(wrtrcrd->menu_choice) == 2) {

				mainmenu();

			} else {

				wrongchoice();
				wrtrcrd->menu_switch = 1;

			}

	} while (wrtrcrd->menu_switch);

	mainmenu();

}

void writefile(mnc *wrtfl, int *money) {

	clearscreen();

	showresults(wrtfl);	//������� ������������ ������� ��� �������� �����
	
	char *line = calloc(23, sizeof(char));
	int position = 1;

		printf("\n\n	�� ������ �������� ���� ��������� � ����� �� �����\n");
		printf("	(������� ������ ����� ������������)\n");

			do {				//��������� ���������������� ����

				wrtfl->menu_switch = 0;

				printf("\n	������� ����� ������: ");
				scanf("%s", wrtfl->menu_choice);

					switch(atoi(wrtfl->menu_choice)) {

						case 1:
							position = 1;
							getresultline(line, money, position);
							break;		
						case 2:
							position = 2;
							getresultline(line, money, position);
							break;
						case 3:
							position = 3;
							getresultline(line, money, position);
							break;
						case 4:
							position = 4;
							getresultline(line, money, position);
							break;
						case 5:
							position = 5;
							getresultline(line, money, position);
							break;
						case 6:
							position = 6;
							getresultline(line, money, position);
							break;
						case 7:
							position = 7;
							getresultline(line, money, position);
							break;
						default:
							wrongchoice();
							wrtfl->menu_switch = 1;	//����� ���������� ���� ��������
							break;
							
					}	
						
			} while (wrtfl->menu_switch == 1);
			
		FILE *file;
		char table[7][23] = {0};
		int n = 0;

			file = fopen("results.txt", "r");	//���� ����� ���, �������. ���� ����, �� ��������� ��� ��������
				while(n < 7) {

					fgets(*(table + n), 24, file);
					n++;

				}		


			for (n = 0; n < strlen(line); n++) {
				
				table[position - 1][n] = line[n];

			}

		freopen("results.txt", "w", file);

	   	fprintf(file,"%s",table);

		fclose(file);

		clearscreen();
		printf("\n ������..\n");
		sleep(1);
		
}

void getresultline(char *line, int *money, int position) {

	char *name = calloc(9, sizeof(char));
	char *name_lim = calloc(9, sizeof(char));
	char mn[8];
	char ps[0];
	int n = 0;
		printf("\n	������� ���� ��� (�� ����� 9 ������): ");
		scanf("%s", name);
		
			strncpy(name_lim, name, 9);
			sprintf(ps,"%d", position);
			strcat(line, ps);
			strcat(line, ". ");
			sprintf(mn,"%d", *money);

				for(n=strlen(mn);n<7;n++){
					
					strcat(mn, " ");
					
				}
				
			strcat(line, mn);
			strcat(line, " - ");
							for(n=strlen(name_lim);n<9;n++){
					
					strcat(name_lim, " ");
					
				}
			strcat(line, name_lim);


}


