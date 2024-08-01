extends Node

var currentEnergy : int = 0
var maxEnergy : int = 0

var energyNodes : Array[EnergyNode] = []

var pool : Array = []

const energyDisplayOffset : float = 96 + 32

func setEnergyVals(currentEnergy : int, maxEnergy : int = -1):
	if maxEnergy != -1:
		setMaxEnergy(maxEnergy)

func setMaxEnergy(maxEnergy : int) -> void:
	if maxEnergy > self.maxEnergy:
		for i in range(maxEnergy - self.maxEnergy):
			createEnergyNode()
	elif maxEnergy < self.maxEnergy:
		for i in range(self.maxEnergy - maxEnergy):
			removeEnergyNode()

func setCurrentEnergy(currentEnergy : int) -> void:
	self.currentEnergy = currentEnergy
	for i in range(maxEnergy):
		energyNodes[i].setUsed(i < currentEnergy)

func createEnergyNode() -> EnergyNode:
	var newEnergyNode : EnergyNode = null
	if pool.size() > 0:
		newEnergyNode = pool.pop_front()
	else:
		newEnergyNode = Preloader.energyNode.instantiate()
	add_child(newEnergyNode)
	newEnergyNode.position.x = maxEnergy * energyDisplayOffset
	newEnergyNode.setUsed(true)
	maxEnergy += 1
	energyNodes.append(newEnergyNode)
	return newEnergyNode

func removeEnergyNode() -> void:
	if maxEnergy > 0:
		var removedEnergyNode = energyNodes.pop_back()
		remove_child(removedEnergyNode)
		pool.append(removedEnergyNode)

func _exit_tree():
	for toFree in pool:
		toFree.free()
