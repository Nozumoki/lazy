--Radiant Star Mai
local s,id=GetID()
function c84013244.initial_effect(c)
	--coin
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_COIN)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(s.cointg)
	e1:SetOperation(s.coinop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
end
s.listed_series={0xF9F}
s.toss_coin=true
function s.cointg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local res=Duel.TossCoin(tp,1)
	if res==1 then 
		if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil) end
    		Duel.SetOperationInfo(0,CATEGORY_TOHAND+CATEGORY_SEARCH,nil,1,tp,LOCATION_DECK)
			e:SetLabel(0)
	elseif Duel.IsExistingTarget(s.rmfilter,tp,0,LOCATION_SZONE,1,nil) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local g=Duel.SelectTarget(tp,s.rmfilter,tp,0,LOCATION_SZONE,1,1,nil) 
			Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
			e:SetLabel(1)
	else e:SetLabel(3) end
end
function s.rmfilter(c)
	return c:IsAbleToRemove()
end
function s.filter(c)
	return c:IsSetCard(0xF9F) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function s.coinop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local label=e:GetLabel()
	if label==0 then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil) 
			if #g>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
	elseif label==3 then
		return false
	else local tc=Duel.GetFirstTarget()
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT) end
	end