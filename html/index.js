let currentVehicle = null;
let isKeyfobOpen = false;

// Initialize the interface
document.addEventListener('DOMContentLoaded', function() {
    // Hide the keyfob initially
    document.getElementById('keyfob-container').style.display = 'none';
    
    // Add event listeners for keyboard shortcuts
    document.addEventListener('keydown', function(event) {
        if (event.key === 'Escape' && isKeyfobOpen) {
            closeKeyfob();
        }
    });
});

// Listen for messages from the game
window.addEventListener('message', function(event) {
    const data = event.data;
    
    switch(data.type) {
        case 'openKeyfob':
            openKeyfob(data.vehicle, data.config);
            break;
        case 'closeKeyfob':
            closeKeyfob();
            break;
        case 'updateVehicleInfo':
            updateVehicleInfo(data.vehicle);
            break;
        case 'playSound':
            playSound(data.sound);
            break;
    }
});

// Open keyfob interface
function openKeyfob(vehicle, config) {
    if (isKeyfobOpen) return;
    
    currentVehicle = vehicle;
    isKeyfobOpen = true;
    
    // Show the container
    const container = document.getElementById('keyfob-container');
    container.style.display = 'flex';
    
    // Trigger animation
    setTimeout(() => {
        container.classList.add('show');
    }, 10);
    
    // Update vehicle information
    updateVehicleInfo(vehicle);
    
    // Update UI based on config
    updateUIFromConfig(config);
}

// Close keyfob interface
function closeKeyfob() {
    if (!isKeyfobOpen) return;
    
    isKeyfobOpen = false;
    
    // Hide the container
    const container = document.getElementById('keyfob-container');
    container.classList.remove('show');
    
    setTimeout(() => {
        container.style.display = 'none';
    }, 300);
    
    // Send close event to game
    fetch(`https://${GetParentResourceName()}/closeKeyfob`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({})
    });
}

// Update vehicle information display
function updateVehicleInfo(vehicle) {
    if (!vehicle) return;
    
    // Update plate number
    document.getElementById('plate-number').textContent = vehicle.plate || 'N/A';
    
    // Update engine status
    const engineStatus = document.getElementById('engine-status');
    if (vehicle.engineRunning) {
        engineStatus.classList.add('running');
        engineStatus.innerHTML = '<i class="fas fa-power-off"></i>';
    } else {
        engineStatus.classList.remove('running');
        engineStatus.innerHTML = '<i class="fas fa-power-off"></i>';
    }
    
    // Update lock status
    const lockStatus = document.getElementById('lock-status');
    if (vehicle.locked) {
        lockStatus.classList.add('locked');
        lockStatus.innerHTML = '<i class="fas fa-lock"></i>';
    } else {
        lockStatus.classList.remove('locked');
        lockStatus.innerHTML = '<i class="fas fa-unlock"></i>';
    }
    
    // Update fuel level
    if (vehicle.fuel !== undefined) {
        document.getElementById('fuel-value').textContent = Math.round(vehicle.fuel) + '%';
        
        // Change color based on fuel level
        const fuelStat = document.getElementById('fuel-stat');
        if (vehicle.fuel < 20) {
            fuelStat.style.color = '#e74c3c';
        } else if (vehicle.fuel < 50) {
            fuelStat.style.color = '#f39c12';
        } else {
            fuelStat.style.color = '#2ecc71';
        }
    }
    
    // Update speed
    if (vehicle.speed !== undefined) {
        document.getElementById('speed-value').textContent = vehicle.speed + ' km/h';
    }
    
    // Update door status
    if (vehicle.doors) {
        for (let i = 0; i < 4; i++) {
            const doorBtn = document.getElementById(`door-${i}`);
            if (doorBtn) {
                if (vehicle.doors[i]) {
                    doorBtn.classList.add('open');
                    doorBtn.innerHTML = '<i class="fas fa-door-open"></i><span>' + getDoorName(i) + '</span>';
                } else {
                    doorBtn.classList.remove('open');
                    doorBtn.innerHTML = '<i class="fas fa-door-closed"></i><span>' + getDoorName(i) + '</span>';
                }
            }
        }
    }
    
    // Update window status
    if (vehicle.windows) {
        for (let i = 0; i < 4; i++) {
            const windowBtn = document.getElementById(`window-${i}`);
            if (windowBtn) {
                if (vehicle.windows[i]) {
                    windowBtn.classList.add('open');
                    windowBtn.innerHTML = '<i class="fas fa-window-maximize"></i><span>' + getWindowName(i) + '</span>';
                } else {
                    windowBtn.classList.remove('open');
                    windowBtn.innerHTML = '<i class="fas fa-window-maximize"></i><span>' + getWindowName(i) + '</span>';
                }
            }
        }
    }
    
    // Update trunk and hood status
    if (vehicle.trunkOpen !== undefined) {
        const trunkBtn = document.getElementById('trunk-btn');
        if (trunkBtn) {
            if (vehicle.trunkOpen) {
                trunkBtn.classList.add('open');
                trunkBtn.innerHTML = '<i class="fas fa-box-open"></i><span class="btn-label">Close Trunk</span>';
            } else {
                trunkBtn.classList.remove('open');
                trunkBtn.innerHTML = '<i class="fas fa-box"></i><span class="btn-label">Open Trunk</span>';
            }
        }
    }
    
    if (vehicle.hoodOpen !== undefined) {
        const hoodBtn = document.getElementById('hood-btn');
        if (hoodBtn) {
            if (vehicle.hoodOpen) {
                hoodBtn.classList.add('open');
                hoodBtn.innerHTML = '<i class="fas fa-car"></i><span class="btn-label">Close Hood</span>';
            } else {
                hoodBtn.classList.remove('open');
                hoodBtn.innerHTML = '<i class="fas fa-car"></i><span class="btn-label">Open Hood</span>';
            }
        }
    }
    
    // Disable buttons if player doesn't have keys
    const hasKey = vehicle.hasKey !== false; // Default to true if not specified
    updateButtonStates(hasKey);
}

// Update UI based on configuration
function updateUIFromConfig(config) {
    if (!config) return;
    
    // Show/hide fuel stat
    const fuelStat = document.getElementById('fuel-stat');
    if (fuelStat) {
        fuelStat.style.display = config.showFuel ? 'flex' : 'none';
    }
    
    // Show/hide speed stat
    const speedStat = document.getElementById('speed-stat');
    if (speedStat) {
        speedStat.style.display = config.showSpeed ? 'flex' : 'none';
    }
    
    // Show/hide engine controls
    const engineBtn = document.getElementById('engine-btn');
    if (engineBtn) {
        engineBtn.style.display = config.showEngine ? 'flex' : 'none';
    }
    
    // Show/hide door controls
    const doorControls = document.querySelector('.door-controls');
    if (doorControls) {
        doorControls.style.display = config.showDoors ? 'block' : 'none';
    }
    
    // Show/hide window controls
    const windowControls = document.querySelector('.window-controls');
    if (windowControls) {
        windowControls.style.display = config.showWindows ? 'block' : 'none';
    }
    
    // Show/hide trunk controls
    const trunkBtn = document.getElementById('trunk-btn');
    if (trunkBtn) {
        trunkBtn.style.display = config.showTrunk ? 'flex' : 'none';
    }
    
    // Show/hide hood controls
    const hoodBtn = document.getElementById('hood-btn');
    if (hoodBtn) {
        hoodBtn.style.display = config.showHood ? 'flex' : 'none';
    }
}

// Update button states based on key ownership
function updateButtonStates(hasKey) {
    const buttons = document.querySelectorAll('.control-btn, .door-btn, .window-btn');
    
    buttons.forEach(button => {
        if (!hasKey) {
            button.disabled = true;
            button.title = 'You need the vehicle keys';
        } else {
            button.disabled = false;
            button.title = '';
        }
    });
}

// Control functions
function toggleLock() {
    if (!currentVehicle) return;
    
    const button = document.getElementById('lock-btn');
    button.classList.add('pulse');
    
    fetch(`https://${GetParentResourceName()}/lockVehicle`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({})
    });
    
    setTimeout(() => button.classList.remove('pulse'), 500);
}

function toggleUnlock() {
    if (!currentVehicle) return;
    
    const button = document.getElementById('unlock-btn');
    button.classList.add('pulse');
    
    fetch(`https://${GetParentResourceName()}/lockVehicle`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({})
    });
    
    setTimeout(() => button.classList.remove('pulse'), 500);
}

function toggleEngine() {
    if (!currentVehicle) return;
    
    const button = document.getElementById('engine-btn');
    button.classList.add('pulse');
    
    fetch(`https://${GetParentResourceName()}/toggleEngine`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({})
    });
    
    setTimeout(() => button.classList.remove('pulse'), 500);
}

function toggleTrunk() {
    if (!currentVehicle) return;
    
    const button = document.getElementById('trunk-btn');
    button.classList.add('pulse');
    
    fetch(`https://${GetParentResourceName()}/toggleTrunk`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({})
    });
    
    setTimeout(() => button.classList.remove('pulse'), 500);
}

function toggleHood() {
    if (!currentVehicle) return;
    
    const button = document.getElementById('hood-btn');
    button.classList.add('pulse');
    
    fetch(`https://${GetParentResourceName()}/toggleHood`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({})
    });
    
    setTimeout(() => button.classList.remove('pulse'), 500);
}

function toggleWindow(windowIndex) {
    if (!currentVehicle) return;
    
    const button = document.getElementById(`window-${windowIndex}`);
    button.classList.add('pulse');
    
    fetch(`https://${GetParentResourceName()}/toggleWindow`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({ windowIndex: windowIndex })
    });
    
    setTimeout(() => button.classList.remove('pulse'), 500);
}

function toggleDoor(doorIndex) {
    if (!currentVehicle) return;
    
    const button = document.getElementById(`door-${doorIndex}`);
    button.classList.add('pulse');
    
    fetch(`https://${GetParentResourceName()}/toggleDoor`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({ doorIndex: doorIndex })
    });
    
    setTimeout(() => button.classList.remove('pulse'), 500);
}

function triggerAlarm() {
    if (!currentVehicle) return;
    
    const button = document.getElementById('alarm-btn');
    button.classList.add('shake');
    
    fetch(`https://${GetParentResourceName()}/triggerAlarm`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({})
    });
    
    setTimeout(() => button.classList.remove('shake'), 300);
}

// Play sound effects
function playSound(soundName) {
    const audio = document.getElementById(`${soundName}-sound`);
    if (audio) {
        audio.currentTime = 0;
        audio.play().catch(e => console.log('Audio play failed:', e));
    }
}

// Helper functions
function getDoorName(index) {
    const names = ['Driver', 'Passenger', 'Rear Left', 'Rear Right'];
    return names[index] || `Door ${index}`;
}

function getWindowName(index) {
    const names = ['Driver', 'Passenger', 'Rear Left', 'Rear Right'];
    return names[index] || `Window ${index}`;
}

// Auto-update vehicle info every second when keyfob is open
setInterval(() => {
    if (isKeyfobOpen && currentVehicle) {
        fetch(`https://${GetParentResourceName()}/updateVehicleInfo`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({})
        }).then(response => response.json()).then(data => {
            if (data) {
                updateVehicleInfo(data);
            }
        }).catch(e => console.log('Failed to update vehicle info:', e));
    }
}, 1000);
