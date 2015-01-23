// BlackHole
#pragma once

#include "IEntity.h"
#include "ISpell.h"

class CPlayer;

class					Spell : public ISpell
{
public:
	Spell(CPlayer *player);
	~Spell();
	Spell(Spell const &);
	Spell				&operator=(Spell const &);

	bool				OnSpell1();
	bool				OnSpell2();
	bool				OnSpell3();
	bool				OnSpellUlt();
	bool				useSpell();
	bool				cancelSpell();
	void				update();
	void				dellSpell();
	void				reset();

private:
	CPlayer				*_player;

	bool				_AttOk;
	bool				_delay;
	float				_timeS1;
	float				_timeS2;
	float				_timeS3;
	float				_timeUlti;
	float				_delayS1;
	float				_delayS2;
	float				_delayS3;
	float				_delayS4;
	int					_nbSpell;
	int					_distance;
	IEntity				*_mark;
	IEntity				*_s1;
	IEntity				*_s2;
	IEntity				*_s3;
	IEntity				*_s4;
};

// BlackHole