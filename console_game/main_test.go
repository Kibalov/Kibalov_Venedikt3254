package main

import (
	"testing"

	"github.com/Kibalov/Kibalov_Venedikt3254/console_game/player"
	"github.com/stretchr/testify/assert"
)

func TestIsCharacterDead(t *testing.T) {
	rabbit := player.Character{}
	rabbit.SetBaseStats()
	assert.False(t, rabbit.IsCharacterDead())
}

func TestNight(t *testing.T) {
	rabbit := player.Character{}
	rabbit.SetBaseStats()
	rabbit.Night()
	assert.Equal(t, 120, rabbit.Health)
	assert.Equal(t, 15, rabbit.Respect)
	assert.Equal(t, 8, rabbit.HoleLenth)
	assert.Equal(t, 25, rabbit.Weight)
}

func TestDigIntensive(t *testing.T) {
	rabbit := player.Character{}
	rabbit.SetBaseStats()
	rabbit.DigIntensive()
	assert.Equal(t, 70, rabbit.Health)
	assert.Equal(t, 15, rabbit.HoleLenth)
}

func TestDigNormal(t *testing.T) {
	rabbit := player.Character{}
	rabbit.SetBaseStats()
	rabbit.DigNormal()
	assert.Equal(t, 90, rabbit.Health)
	assert.Equal(t, 12, rabbit.HoleLenth)
}

func TestEatWitheredGrass(t *testing.T) {
	rabbit := player.Character{}
	rabbit.SetBaseStats()
	rabbit.EatWitheredGrass()
	assert.Equal(t, 110, rabbit.Health)
	assert.Equal(t, 45, rabbit.Weight)
}

func TestEatGreenGrass(t *testing.T) {
	rabbit := player.Character{}
	rabbit.SetBaseStats()
	rabbit.Respect = 30
	rabbit.EatGreenGrass()
	assert.Equal(t, 130, rabbit.Health)
	assert.Equal(t, 60, rabbit.Weight)
}

func TestEatGreenGrassWithLowRespect(t *testing.T) {
	rabbit := player.Character{}
	rabbit.SetBaseStats()
	rabbit.Respect = 10
	rabbit.EatGreenGrass()
	assert.Equal(t, 70, rabbit.Health)
}
