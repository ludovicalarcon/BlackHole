// BlackHole
#pragma once

class					ISpell
{
public:
	virtual ~ISpell() {}

	virtual bool		OnSpell1() = 0;
	virtual bool		OnSpell2() = 0;
	virtual bool		OnSpell3() = 0;
	virtual bool		OnSpellUlt() = 0;
	virtual bool		useSpell() = 0;
	virtual bool		cancelSpell() = 0;
	virtual void		update() = 0;
	virtual void		dellSpell() = 0;
	virtual void		reset() = 0;
};
// BlackHole