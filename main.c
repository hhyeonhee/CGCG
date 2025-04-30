#include <stdio.h>
#include <unistd.h> // 상수들을 정의해놓음
#include <pthread.h> // 스레드 생성
#include <stdlib.h>  // 시스템 클리어 사용위해
#include <time.h>

#define CLEAR system("clear")
#define MAP_SIZE 10
#define COUNT_DOWN 15
#define INIT 0

int map[MAP_SIZE][MAP_SIZE] = {0}; // 맵사이즈 10*10

typedef enum {WHITE = 0, RED, BLUE} TILE_COLOR; // 타일색깔 열거
typedef enum {WALL = 10, PLAYER_1, PLAYER_2} ICON; // 아이콘타입 열거

int player_1_location[2] = {0, 0}; // 1p 시작좌표값
int player_2_location[2] = {9, 9}; // 2p 시작좌표값

void* player_1(void* move);
void* player_2(void* action);
void* timemap_main(void* minute);
// void* map_area(void* locate);
void map_print();
void tile_count();

void wait(int seconds) // 작동법은 나도모름 이렇게 쓴다더라
{
    clock_t endwait;
    endwait = clock() + seconds * CLOCKS_PER_SEC;
    while (clock() < endwait) {
    }
}


int game_num;

int main()
{
    
    printf("─────────[ 땅따먹기 게임 ]─────────────\n");
    printf("          1. 시작하기                  \n");
    printf("          2. 종료하기                  \n");
    printf("──────────────────────────────────────\n");
    printf("번호를 선택하세요: \n");
    scanf("%d",&game_num);

    while(1)
    {   
        getchar();
        if(game_num == 1){

            pthread_t p1,p2,time,map;

            pthread_create(&time,NULL, timemap_main, NULL);
            pthread_create(&p1,NULL,player_1,NULL);
            pthread_create(&p2,NULL,player_2,NULL);
            // pthread_create(&map,NULL,map_area,NULL);
            pthread_detach(p1);
            pthread_detach(p2);
            pthread_detach(time);
            // pthread_detach(map);   
        }
        else if(game_num == 2){
            printf("게임을 종료합니다.\n");
            break;
        }
        else{
            printf("1번 2번 둘중하나를 선택하세요.\n");
            getchar();
        }
    }
    return 0;
}
// player1 함수
void* player_1(void* move){ // void* : 어떤 타입의 형태든 상관없이 포인터로 변화가능
    printf("플레이어1의 스레드가 생성되었나요?\n");
}
//player2 함수
void* player_2(void* action){
    printf("플레이어2의 스레드가 생성되었나요?\n");

}
//time 함수
void* timemap_main(void* minute)
{
    // printf("시간 스레드가 생성되었나요?\n");
    int n;
    printf("Starting game...\n");
    for (n = COUNT_DOWN; n > 0; n--) 
    {
        printf("[ ⏰ Timer : %d ]\n", n);
        //맵파일출력 map_pthread
        map_print(); // 맵 출력
        wait(1);
        CLEAR;
    }
    tile_count(); // 타일 개수
}

//map 함수
// void* map_area(void* locate)
// {
//     map_print();
//     tile_count();
//     printf("맵 스레드가 생성되었나요?\n");
// }

void map_print() // 맵 출력
{
    for(int i = INIT; i < MAP_SIZE; i++) // i = y좌표
    {
        for(int j = INIT; j < MAP_SIZE; j++)  // j = x좌표
        {
            if(player_1_location[0] == i && player_1_location[1] == j)  // 플레이어1 좌표 표시
            {
                printf("🦀 ");
            }
            else if(player_2_location[0] == i && player_2_location[1] == j) // 플레이어2 좌표 표시
            {
                printf("🐬 ");
            }
            else if(map[i][j] == RED)  //  map[i][j]가 1이면 빨간타일 출력
            {
                printf("🟥 ");
            }
            else if(map[i][j] == BLUE)  // map[i][j]가 2이면 파란타일 출력
            {
                printf("🟦 ");
            }
            else if(map[i][j] == WHITE)  //map[i][j]가 0이면 하얀타일 출력
            {
                printf("⬜ ");
            }   
        }
        printf("\n");
    }
}

void tile_count() // 타일 개수와 승자 출력
{
    int red_count = INIT;  // 빨간 타일 개수
    int blue_count = INIT;  // 파란 타일 개수

    for (int i = INIT; i < MAP_SIZE; i++)
    {
        for(int j = INIT; j < MAP_SIZE; j++)
        {
            if(map[i][j] == RED)
            {
                red_count ++;
            }
            else if(map[i][j] == BLUE)
            {
                blue_count ++;
            }
        }
    }

    printf("PLAYER_1 : %d / PLAYER_2 : %d\n", red_count, blue_count);
    
    if(red_count > blue_count) // 빨간타일이 블루타일보다 많을때 플레이어1이 이김
    {
        printf("WINNER is Player_1 🦀\n");
    }
    else if (red_count < blue_count)// 빨간타일이 블루타일보다 적을때 플레이어2이 이김
    {
        printf("WINNER is Player_2 🐬\n");
    }
    else{printf("draw!\n");} // 무승부
}