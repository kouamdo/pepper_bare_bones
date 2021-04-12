#ifndef _VIDEO_H_
#define _VIDEO_H_

#define LOADING_COLOR \
    0XF1 // Couleur dédié pour le chargement d'une fonctionnalité
#define READY_COLOR \
    0X07                  // Couleur dédié pour une action qui c'est déjà produite
#define ADVICE_COLOR 0X06 // Couleur pour les conseils
#define ERROR_COLOR  0x04 // Couleur pour les erreurs

#define VIDEO_MEM 0xb8000

void volatile cclean();
void volatile cputchar(unsigned char color, unsigned const char c);
void init_console();
#endif // !VIDEO_H
