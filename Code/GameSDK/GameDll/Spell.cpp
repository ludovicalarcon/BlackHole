// BlackHole

#include "stdAfx.h"
#include "Spell.h"
#include "Player.h"

Spell::Spell(CPlayer *player) : _player(player)
{
	_AttOk = false;
	_timeS1 = 0.f;
	_timeS2 = 0.f;
	_timeS3 = 0.f;
	_timeUlti = 0.f;
	_nbSpell = 0;
	_mark = NULL;
	_delayS1 = 0.f;
	_delayS2 = 0.f;
	_delayS3 = 0.f;
	_delayS4 = 0.f;
	_delay = true;
	_s1 = NULL;
	_s2 = NULL;
	_s3 = NULL;
	_s4 = NULL;
	_distance = 0;
}

Spell::~Spell()
{
	if (_mark)
		delete _mark;
}

Spell::Spell(Spell const &spell)
{
	this->operator=(spell);
}

Spell	&Spell::operator=(Spell const &spell)
{
	_AttOk = spell._AttOk;
	_timeS1 = spell._timeS1;
	_timeS2 = spell._timeS2;
	_timeS3 = spell._timeS3;
	_timeUlti = spell._timeUlti;
	_nbSpell = spell._nbSpell;
	_mark = spell._mark;
	_delay = spell._delay;
	_delayS1 = spell._delayS1;
	_delayS2 = spell._delayS2;
	_delayS3 = spell._delayS3;
	_delayS4 = spell._delayS4;
	_s1 = spell._s1;
	_s2 = spell._s2;
	_s3 = spell._s3;
	_s4 = spell._s4;
	_distance = spell._distance;
	_player = spell._player;
	return *this;
}

bool Spell::OnSpell1()
{
	SEntitySpawnParams entitySpawnParams;

	if (_delayS1 > 0 && gEnv->pTimer->GetCurrTime() <= _delayS1 + 2)
		return false;
	if (_mark)
		gEnv->pEntitySystem->RemoveEntity(_mark->GetId(), true);
	_distance = 7;
	entitySpawnParams.pClass = gEnv->pEntitySystem->GetClassRegistry()->GetDefaultClass();
	entitySpawnParams.sName = "mark";
	entitySpawnParams.vPosition = Vec3(_player->GetEntity()->GetPos().x + _distance * _player->GetViewRotation().GetColumn1().x, _player->GetEntity()->GetPos().y + _distance * _player->GetViewRotation().GetColumn1().y, _player->GetEntity()->GetPos().z);
	entitySpawnParams.vScale(1.5, 1.5, 1.5);
	entitySpawnParams.id = 5;
	_mark = gEnv->pEntitySystem->SpawnEntity(entitySpawnParams);
	if (!_mark)
		return false;
	_mark->LoadGeometry(0, "Objects/default/primitive_plane_small.cgf");
	IMaterial * mat = gEnv->p3DEngine->GetMaterialManager()->LoadMaterial("some_material");
	_mark->SetMaterial(mat);
	_AttOk = true;
	_nbSpell = 1;
	return true;
}

bool Spell::OnSpell2()
{
	SEntitySpawnParams entitySpawnParams;

	if (_delayS2 > 0 && gEnv->pTimer->GetCurrTime() <= _delayS2 + 2)
		return false;
	if (_mark)
		gEnv->pEntitySystem->RemoveEntity(_mark->GetId(), true);
	_distance = 10;
	entitySpawnParams.pClass = gEnv->pEntitySystem->GetClassRegistry()->GetDefaultClass();
	entitySpawnParams.sName = "mark";
	entitySpawnParams.vPosition = Vec3(_player->GetEntity()->GetPos().x + _distance * _player->GetViewRotation().GetColumn1().x, _player->GetEntity()->GetPos().y + _distance * _player->GetViewRotation().GetColumn1().y, _player->GetEntity()->GetPos().z);
	entitySpawnParams.vScale(1.5, 1.5, 1.5);
	entitySpawnParams.id = 5;
	_mark = gEnv->pEntitySystem->SpawnEntity(entitySpawnParams);
	if (!_mark)
		return false;
	_mark->LoadGeometry(0, "Objects/default/primitive_plane_small.cgf");
	IMaterial * mat = gEnv->p3DEngine->GetMaterialManager()->LoadMaterial("some_material");
	_mark->SetMaterial(mat);
	_AttOk = true;
	_nbSpell = 2;
	return true;
}

bool Spell::OnSpell3()
{
	SEntitySpawnParams entitySpawnParams;

	if (_delayS3 > 0 && gEnv->pTimer->GetCurrTime() <= _delayS3 + 2)
		return false;
	if (_mark)
		gEnv->pEntitySystem->RemoveEntity(_mark->GetId(), true);
	_distance = 5;
	entitySpawnParams.pClass = gEnv->pEntitySystem->GetClassRegistry()->GetDefaultClass();
	entitySpawnParams.sName = "mark";
	entitySpawnParams.vPosition = Vec3(_player->GetEntity()->GetPos().x + _distance * _player->GetViewRotation().GetColumn1().x, _player->GetEntity()->GetPos().y + _distance * _player->GetViewRotation().GetColumn1().y, _player->GetEntity()->GetPos().z);
	entitySpawnParams.vScale(1.5, 1.5, 1.5);
	entitySpawnParams.id = 5;
	_mark = gEnv->pEntitySystem->SpawnEntity(entitySpawnParams);
	if (!_mark)
		return false;
	_mark->LoadGeometry(0, "Objects/default/primitive_plane_small.cgf");
	IMaterial * mat = gEnv->p3DEngine->GetMaterialManager()->LoadMaterial("some_material");
	_mark->SetMaterial(mat);
	_AttOk = true;
	_nbSpell = 3;
	return true;
}

bool Spell::OnSpellUlt()
{
	SEntitySpawnParams entitySpawnParams;

	if (_delayS4 > 0 && gEnv->pTimer->GetCurrTime() <= _delayS4 + 3)
		return false;
	if (_mark)
		gEnv->pEntitySystem->RemoveEntity(_mark->GetId(), true);
	_distance = 9;
	entitySpawnParams.pClass = gEnv->pEntitySystem->GetClassRegistry()->GetDefaultClass();
	entitySpawnParams.sName = "mark";
	entitySpawnParams.vPosition = Vec3(_player->GetEntity()->GetPos().x + _distance * _player->GetViewRotation().GetColumn1().x, _player->GetEntity()->GetPos().y + _distance * _player->GetViewRotation().GetColumn1().y, _player->GetEntity()->GetPos().z);
	entitySpawnParams.vScale(2.5, 2.5, 2.5);
	entitySpawnParams.id = 5;
	_mark = gEnv->pEntitySystem->SpawnEntity(entitySpawnParams);
	if (!_mark)
		return false;
	_mark->LoadGeometry(0, "Objects/default/primitive_plane_small.cgf");
	IMaterial * mat = gEnv->p3DEngine->GetMaterialManager()->LoadMaterial("some_material");
	_mark->SetMaterial(mat);
	_AttOk = true;
	_nbSpell = 4;
	return true;
}

bool Spell::useSpell()
{
	SEntitySpawnParams entitySpawnParams;
	SEntityPhysicalizeParams physParams;
	IEntity *pEntity = NULL;
	Vec3 _playerPos;

	if (_AttOk)
	{
		switch (_nbSpell)
		{
		case 1:
			if (_delayS1 > 0 && gEnv->pTimer->GetCurrTime() <= _delayS1 + 2)
				return false;
			entitySpawnParams.pClass = gEnv->pEntitySystem->GetClassRegistry()->GetDefaultClass();
			entitySpawnParams.sName = "Sort1";
			entitySpawnParams.vPosition = Vec3(_player->GetEntity()->GetPos().x + _distance * _player->GetViewRotation().GetColumn1().x, _player->GetEntity()->GetPos().y + _distance * _player->GetViewRotation().GetColumn1().y, _player->GetEntity()->GetPos().z + 3);
			entitySpawnParams.id = 0;
			entitySpawnParams.vScale(0.4, 0.4, 0.4);
			pEntity = gEnv->pEntitySystem->SpawnEntity(entitySpawnParams);
			if (!pEntity)
			{
				_AttOk = false;
				return false;
			}
			pEntity->LoadGeometry(0, "Objects/default/primitive_sphere.cgf");
			physParams.type = PE_RIGID;
			physParams.mass = 70;
			pEntity->Physicalize(physParams);
			if (_mark)
				gEnv->pEntitySystem->RemoveEntity(_mark->GetId(), true);
			_mark = NULL;
			_timeS1 = gEnv->pTimer->GetCurrTime();
			_s1 = pEntity;
			_delayS1 = gEnv->pTimer->GetCurrTime();
			_delay = false;
			break;
		case 2:
			if (_delayS2 > 0 && gEnv->pTimer->GetCurrTime() <= _delayS2 + 2)
				return false;
			entitySpawnParams.pClass = gEnv->pEntitySystem->GetClassRegistry()->GetDefaultClass();
			entitySpawnParams.sName = "Sort2";
			entitySpawnParams.vPosition = Vec3(_player->GetEntity()->GetPos().x + _distance * _player->GetViewRotation().GetColumn1().x, _player->GetEntity()->GetPos().y + _distance * _player->GetViewRotation().GetColumn1().y, _player->GetEntity()->GetPos().z + 3);
			entitySpawnParams.id = 0;
			entitySpawnParams.vScale(0.5, 0.5, 0.5);
			pEntity = gEnv->pEntitySystem->SpawnEntity(entitySpawnParams);
			if (!pEntity)
			{
				_AttOk = false;
				return false;
			}
			pEntity->LoadGeometry(0, "Objects/default/primitive_pyramid.cgf");
			physParams.type = PE_RIGID;
			physParams.mass = 70;
			pEntity->Physicalize(physParams);
			if (_mark)
				gEnv->pEntitySystem->RemoveEntity(_mark->GetId(), true);
			_mark = NULL;
			_timeS2 = gEnv->pTimer->GetCurrTime();
			_s2 = pEntity;
			_delayS2 = gEnv->pTimer->GetCurrTime();
			_delay = false;
			break;
		case 3:
			if (_delayS3 > 0 && gEnv->pTimer->GetCurrTime() <= _delayS3 + 2)
				return false;
			_player->GetEntity()->SetPos(Vec3(_player->GetEntity()->GetPos().x + _distance * _player->GetViewRotation().GetColumn1().x, _player->GetEntity()->GetPos().y + _distance * _player->GetViewRotation().GetColumn1().y, _player->GetEntity()->GetPos().z));
			if (_mark)
				gEnv->pEntitySystem->RemoveEntity(_mark->GetId(), true);
			_mark = NULL;
			_delayS3 = gEnv->pTimer->GetCurrTime();
			_delay = false;
			break;
		case 4:
			if (_delayS4 > 0 && gEnv->pTimer->GetCurrTime() <= _delayS4 + 3)
				return false;
			entitySpawnParams.pClass = gEnv->pEntitySystem->GetClassRegistry()->GetDefaultClass();
			entitySpawnParams.sName = "Ulti";
			entitySpawnParams.vPosition = Vec3(_player->GetEntity()->GetPos().x + _distance * _player->GetViewRotation().GetColumn1().x, _player->GetEntity()->GetPos().y + _distance * _player->GetViewRotation().GetColumn1().y, _player->GetEntity()->GetPos().z);
			entitySpawnParams.id = 0;
			entitySpawnParams.vScale(0.9, 0.9, 1.5);
			pEntity = gEnv->pEntitySystem->SpawnEntity(entitySpawnParams);
			if (!pEntity)
			{
				_AttOk = false;
				return false;
			}
			pEntity->LoadGeometry(0, "Objects/default/primitive_cylinder.cgf");
			physParams.type = PE_RIGID;
			physParams.mass = 200;
			pEntity->Physicalize(physParams);
			if (_mark)
				gEnv->pEntitySystem->RemoveEntity(_mark->GetId(), true);
			_mark = NULL;
			_timeUlti = gEnv->pTimer->GetCurrTime();
			_s4 = pEntity;
			_delayS4 = gEnv->pTimer->GetCurrTime();
			_delay = false;
			break;
		default:
			return false;
			break;
		}
	}
	_AttOk = false;
	return true;
}

bool Spell::cancelSpell()
{
	_AttOk = false;
	_nbSpell = 0;
	if (_mark)
		gEnv->pEntitySystem->RemoveEntity(_mark->GetId(), true);
	_mark = NULL;
	return true;
}

void Spell::update()
{
	if (_mark)
		_mark->SetPos(Vec3(_player->GetEntity()->GetPos().x + _distance * _player->GetViewRotation().GetColumn1().x, _player->GetEntity()->GetPos().y + _distance * _player->GetViewRotation().GetColumn1().y, _player->GetEntity()->GetPos().z));
}

void Spell::dellSpell()
{
	float currentTime = gEnv->pTimer->GetCurrTime();
	if (currentTime >= _timeS1 + 1 && _s1)
	{
		gEnv->pEntitySystem->RemoveEntity(_s1->GetId(), false);
		_s1 = NULL;
	}
	else if (_s2 && currentTime >= _timeS2 + 1)
	{
		gEnv->pEntitySystem->RemoveEntity(_s2->GetId(), false);
		_s2 = NULL;
	}
	else if (_s4 && currentTime >= _timeUlti + 1.5)
	{
		gEnv->pEntitySystem->RemoveEntity(_s4->GetId(), false);
		_s4 = NULL;
	}
}

void Spell::reset()
{
	_AttOk = false;
	_timeS1 = 0.f;
	_timeS2 = 0.f;
	_timeS3 = 0.f;
	_timeUlti = 0.f;
	_nbSpell = 0;
	_mark = NULL;
	_delayS1 = 0.f;
	_delayS2 = 0.f;
	_delayS3 = 0.f;
	_delayS4 = 0.f;
	_delay = true;
	_s1 = NULL;
	_s2 = NULL;
	_s3 = NULL;
	_s4 = NULL;
	_distance = 0;
}

// BlackHole