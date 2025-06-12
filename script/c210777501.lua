--Triamid Chieftain 
--designed by FlaryFlare
--scripted by Naim
local s,id=GetID()
function s.initial_effect(c)
	--Place 1 "Triamid" Field Spell from your Deck, face-up in your Field Zone, then you can Normal Summon 1 Rock monster
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.tftg)
	e1:SetOperation(s.tfop)
	c:RegisterEffect(e1)
	--Activate 1 "Triamid" Field Spell from the Deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,{id,1})
	e2:SetCondition(function() return Duel.IsMainPhase() end)
	e2:SetTarget(s.replacefieldtg)
	e2:SetOperation(s.replacefieldop)
	c:RegisterEffect(e2)
end
s.listed_series={SET_TRIAMID}
function s.tffilter(c,tp)
	return c:IsSetCard(SET_TRIAMID) and c:IsFieldSpell() and not c:IsForbidden()
end
function s.pltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.plfilter,tp,LOCATION_DECK,0,1,nil) end
end
function s.nsfilter(c)
	return c:IsRace(RACE_ROCK) and c:IsSummonable(true,nil)
end
function s.plop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,s.plfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc then
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		if Duel.MoveToField(sc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
			and Duel.IsExistingMatchingCard(s.nsfilter,tp,LOCATION_HAND|LOCATION_MZONE,0,1,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
			local sc=Duel.SelectMatchingCard(tp,s.nsfilter,tp,LOCATION_HAND|LOCATION_MZONE,0,1,1,nil):GetFirst()
			if sc then
				Duel.BreakEffect()
				Duel.Summon(tp,sc,true,nil)
			end
		end
	end
end
function s.tofieldfilter(c,tp)
	return c:IsFieldSpell() and c:IsSetCard(SET_TRIAMID) and c:GetActivateEffect():IsActivatable(tp,true, true)
end
function s.replacefieldtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return return chkc:IsAbleToGrave() and chkc:IsLocation(LOCATION_ONFIELD) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToGrave,tp,LOCATION_FZONE,LOCATION_FZONE,1,nil)
		and Duel.IsExistingMatchingCard(s.tofieldfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToGrave,tp,LOCATION_FZONE,LOCATION_FZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,tp,0)
end
function s.replacefieldop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoGrave(tc,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_GRAVE) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local fc=Duel.SelectMatchingCard(tp,s.tofieldfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
		Duel.ActivateFieldSpell(fc,e,tp,eg,ep,ev,re,r,rp)
	end
end