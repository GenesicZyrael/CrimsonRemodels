--剣聖の影霊衣－セフィラセイバー
--Zefrasaber, Swordmaster of the Nekroz
--Modified for CrimsonAlpha
local s,id=GetID()
function s.initial_effect(c)
	local rparams= {handler=c,
					lvtype=RITPROC_EQUAL,
					desc=aux.Stringid(id,1),
					forcedselection=function(e,tp,g,sc)return g:IsContains(e:GetHandler()) end}
	local rittg,ritop=Ritual.Target(rparams),Ritual.Operation(rparams)
	--pendulum summon
	Pendulum.AddProcedure(c)
	--Ritual Summon
	local e1=Ritual.CreateProc({handler=c,
								lvtype=RITPROC_EQUAL,
								desc=aux.Stringid(id,1),
								forcedselection=function(e,tp,g,sc)return g:IsContains(e:GetHandler()) end})
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE+LOCATION_HAND)
	-- e1:SetCountLimit(1,{id,0})
	c:RegisterEffect(e1)
	--Pendulum Set
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	-- e2:SetCountLimit(1,{id,0})
	e2:SetCondition(s.condition)
	e2:SetOperation(s.operation(rittg,ritop))
	c:RegisterEffect(e2,false,CUSTOM_REGISTER_ZEFRA)
	--splimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e3:SetTargetRange(1,0)
	e3:SetTarget(s.splimit)
	c:RegisterEffect(e3)
end
s.listed_series={SET_NEKROZ,SET_ZEFRA}
s.listed_names={21105106}
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function s.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(SET_NEKROZ) or c:IsSetCard(SET_ZEFRA) then return false end
	return (sumtype&SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_PENDULUM)
end
function s.operation(rittg,ritop)
	return function(e,tp,eg,ep,ev,re,r,rp)
		local rit=rittg(e,tp,eg,ep,ev,re,r,rp,0)
		local c=e:GetHandler()
		if not e:GetHandler():IsRelateToEffect(e) then return end
		if rittg(e,tp,eg,ep,ev,re,r,rp,0) then
			ritop(e,tp,eg,ep,ev,re,r,rp)
		end
	end
end
