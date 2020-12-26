

#ifndef _VIDEO_H_
#define _VIDEO_H_

#define LOADING_COLOR \
    0XF1 // Couleur dédié pour le chargement d'une fonctionnalité
#define READY_COLOR \
    0X07 // Couleur dédié pour une action qui c'est déjà produite
#define ADVICE_COLOR 0X06 // Couleur pour les conseils
#define ERROR_COLOR 0x04  // Couleur pour les erreurs

#define VIDEO_MEM 0xb8000

void volatile write_string(unsigned char colour, const char string[40]);
void volatile pepper_screen();
void volatile scrollup();
void volatile putchar(unsigned char color, unsigned const char c);
void volatile kprintf(int nmber_param, ...);
void volatile print_frequence(unsigned int freq);
/*Print ADDRESS*/

void volatile print_address(unsigned char color, unsigned int adress_);

#endif // !VIDEO_H
