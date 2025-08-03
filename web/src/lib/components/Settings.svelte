<script lang="ts">
	import { Hud } from "$lib/stores/VisibilityStore";
	import { fade, slide } from 'svelte/transition';
	import { fetchNui } from "$lib/utils/fetchNui";

	// Category visibility state
	let displaySettingsOpen = true;
	let performanceSettingsOpen = true;

	function toggleCategory(category: string) {
		if (category === 'display') {
			displaySettingsOpen = !displaySettingsOpen;
		} else if (category === 'performance') {
			performanceSettingsOpen = !performanceSettingsOpen;
		}
	}

	function setCompassSetting(value: string) {
		let ShowCompass = true;
		
		switch (value) {
			case 'vehicle':
				ShowCompass = $Hud.InVehicle;
				break;
			case 'off':
				ShowCompass = false;
				break;
			case 'on':
			default:
				ShowCompass = true;
				break;
		}

		Hud.update(h => ({
			...h,
			ShowCompass: ShowCompass,
			HudSettings: {
				...h.HudSettings,
				ShowCompass: value
			}
		}));

		fetchNui("UpdateSettings", $Hud.HudSettings)
	}
	
	function setStatsSetting(value: string) {
		Hud.update(h => ({
			...h,
			HudSettings: {
				...h.HudSettings,
				Stats: value
			}
		}));

		fetchNui("UpdateSettings", $Hud.HudSettings)
	}

	function setServerInfoSetting(value: string) {
		Hud.update(h => ({
			...h,
			HudSettings: {
				...h.HudSettings,
				ServerInfo: value
			}
		}));

		fetchNui("UpdateSettings", $Hud.HudSettings)
	}

	function setCompassMode(value: string) {
		Hud.update(h => ({
			...h,
			HudSettings: {
				...h.HudSettings,
				CompassMode: value
			}
		}));

		fetchNui("UpdateSettings", $Hud.HudSettings)
	}

	function setCompassInterval(value: string) {
		Hud.update(h => ({
			...h,
			HudSettings: {
				...h.HudSettings,
				CompassInterval: value
			}
		}));

		fetchNui("UpdateCompassInterval", $Hud.HudSettings.CompassInterval)
	}

	function saveSettings() {
		fetchNui("SaveSettings")
	}

	function hideSettings() {
		fetchNui("HideSettings")
			.then((returnData) => {
				if (returnData) {
					Hud.update(h => ({
						...h,
						HudSettings: {
							...h.HudSettings,
							ShowMenu: false
						}
					}));
				}
		})
	}

	function handleKeydown(event: KeyboardEvent) {
		if (event.key === 'Escape' && $Hud.HudSettings.ShowMenu) {
			hideSettings()
		}
	}
</script>

<svelte:head>
	<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
</svelte:head>

<svelte:window on:keydown={handleKeydown} />

<!-- Settings Panel -->
{#if $Hud.HudSettings.ShowMenu}
	<div 
		class="fixed inset-0 z-40 pointer-events-auto"
		transition:fade={{ duration: 200 }}
	>
		
		<!-- Settings panel - centered -->
		<div 
			class="absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 w-[28vh] bg-slate-900/95 rounded-[0.2vh] border border-slate-600/30 shadow-lg font-['Inter'] select-none"
			transition:slide={{ duration: 300 }}
		>
			<!-- Header -->
			<div class="flex items-center justify-between px-[1.5vh] py-[1vh] border-b border-slate-700/40">
				<h2 class="text-slate-100 text-[1.4vh] font-medium">HUD Settings</h2>
				<button 
					on:click={() => hideSettings()}
					class="text-slate-400 hover:text-slate-200 transition-colors duration-200"
				>
					<i class="fas fa-times text-[1.2vh]"></i>
				</button>
			</div>

			<!-- Settings content -->
			<div class="px-[1.5vh] py-[1vh] space-y-[1.2vh] max-h-[50vh] overflow-y-auto">
				
				<!-- Display Settings Category -->
				<div class="space-y-[0.6vh]">
					<button 
						on:click={() => toggleCategory('display')}
						class="flex items-center justify-between w-full text-left group hover:bg-slate-800/30 rounded-[0.2vh] px-[0.6vh] py-[0.4vh] transition-colors duration-200"
					>
						<h3 class="text-slate-200 text-[1.2vh] font-medium">Display Settings</h3>
						<svg 
							class="w-[1vh] h-[1vh] text-slate-400 transition-transform duration-200 {displaySettingsOpen ? 'rotate-180' : ''}"
							fill="none" 
							stroke="currentColor" 
							viewBox="0 0 24 24"
						>
							<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"></path>
						</svg>
					</button>
					
					{#if displaySettingsOpen}
						<div class="space-y-[0.6vh] pl-[0.6vh]" transition:slide={{ duration: 200 }}>
							<!-- Enable Compass -->
							<div class="flex items-center justify-between">
								<label class="text-slate-300 text-[1.1vh] font-medium">Enable Compass</label>
								<div class="relative">
									<select 
										bind:value={$Hud.HudSettings.ShowCompass}
										on:change={(e) => setCompassSetting(e.target.value)}
										class="appearance-none bg-slate-800/60 hover:bg-slate-700/70 focus:bg-slate-700/80 text-slate-200 px-[0.8vh] py-[0.4vh] pr-[2vh] rounded-[0.2vh] border border-slate-600/30 hover:border-slate-500/50 focus:border-emerald-500/50 text-[0.9vh] font-medium min-w-[7vh] transition-all duration-200 cursor-pointer focus:outline-none focus:ring-1 focus:ring-emerald-500/30"
									>
										<option value="on" class="bg-slate-800 text-slate-200">On</option>
										<option value="off" class="bg-slate-800 text-slate-200">Off</option>
										<option value="vehicle" class="bg-slate-800 text-slate-200">Only In Vehicle</option>
									</select>
									<!-- Custom dropdown arrow -->
									<div class="absolute inset-y-0 right-0 flex items-center pr-[0.6vh] pointer-events-none">
										<svg class="w-[0.8vh] h-[0.8vh] text-slate-400 transition-colors duration-200" fill="none" stroke="currentColor" viewBox="0 0 24 24">
											<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"></path>
										</svg>
									</div>
								</div>
							</div>

							<!-- Compass Mode -->
							<div class="flex items-center justify-between">
								<label class="text-slate-300 text-[1.1vh] font-medium">Compass Mode</label>
								<div class="relative">
									<select 
										bind:value={$Hud.HudSettings.CompassMode}
										on:change={(e) => setCompassMode(e.target.value)}
										class="appearance-none bg-slate-800/60 hover:bg-slate-700/70 focus:bg-slate-700/80 text-slate-200 px-[0.8vh] py-[0.4vh] pr-[2vh] rounded-[0.2vh] border border-slate-600/30 hover:border-slate-500/50 focus:border-emerald-500/50 text-[0.9vh] font-medium min-w-[7vh] transition-all duration-200 cursor-pointer focus:outline-none focus:ring-1 focus:ring-emerald-500/30"
									>
										<option value="Camera" class="bg-slate-800 text-slate-200">Camera</option>
										<option value="Character" class="bg-slate-800 text-slate-200">Character</option>
									</select>
									<!-- Custom dropdown arrow -->
									<div class="absolute inset-y-0 right-0 flex items-center pr-[0.6vh] pointer-events-none">
										<svg class="w-[0.8vh] h-[0.8vh] text-slate-400 transition-colors duration-200" fill="none" stroke="currentColor" viewBox="0 0 24 24">
											<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"></path>
										</svg>
									</div>
								</div>
							</div>

							<!-- Stats Display -->
							<div class="flex items-center justify-between">
								<label class="text-slate-300 text-[1.1vh] font-medium">Stats Display</label>
								<div class="relative">
									<select 
										bind:value={$Hud.HudSettings.Stats}
										on:change={(e) => setStatsSetting(e.target.value)}
										class="appearance-none bg-slate-800/60 hover:bg-slate-700/70 focus:bg-slate-700/80 text-slate-200 px-[0.8vh] py-[0.4vh] pr-[2vh] rounded-[0.2vh] border border-slate-600/30 hover:border-slate-500/50 focus:border-emerald-500/50 text-[0.9vh] font-medium min-w-[7vh] transition-all duration-200 cursor-pointer focus:outline-none focus:ring-1 focus:ring-emerald-500/30"
									>
										<option value="A" class="bg-slate-800 text-slate-200">Style A</option>
										<option value="B" class="bg-slate-800 text-slate-200">Style B</option>
										<option value="C" class="bg-slate-800 text-slate-200">Style C</option>
										<option value="Off" class="bg-slate-800 text-slate-200">Off</option>
									</select>
									<!-- Custom dropdown arrow -->
									<div class="absolute inset-y-0 right-0 flex items-center pr-[0.6vh] pointer-events-none">
										<svg class="w-[0.8vh] h-[0.8vh] text-slate-400 transition-colors duration-200" fill="none" stroke="currentColor" viewBox="0 0 24 24">
											<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"></path>
										</svg>
									</div>
								</div>
							</div>

							<!-- ServerInfo Display -->
							<div class="flex items-center justify-between">
								<label class="text-slate-300 text-[1.1vh] font-medium">ServerInfo Display</label>
								<div class="relative">
									<select 
										bind:value={$Hud.HudSettings.ServerInfo}
										on:change={(e) => setServerInfoSetting(e.target.value)}
										class="appearance-none bg-slate-800/60 hover:bg-slate-700/70 focus:bg-slate-700/80 text-slate-200 px-[0.8vh] py-[0.4vh] pr-[2vh] rounded-[0.2vh] border border-slate-600/30 hover:border-slate-500/50 focus:border-emerald-500/50 text-[0.9vh] font-medium min-w-[7vh] transition-all duration-200 cursor-pointer focus:outline-none focus:ring-1 focus:ring-emerald-500/30"
									>
										<option value="A" class="bg-slate-800 text-slate-200">Style A</option>
										<option value="B" class="bg-slate-800 text-slate-200">Style B</option>
										<option value="Off" class="bg-slate-800 text-slate-200">Off</option>
									</select>
									<!-- Custom dropdown arrow -->
									<div class="absolute inset-y-0 right-0 flex items-center pr-[0.6vh] pointer-events-none">
										<svg class="w-[0.8vh] h-[0.8vh] text-slate-400 transition-colors duration-200" fill="none" stroke="currentColor" viewBox="0 0 24 24">
											<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"></path>
										</svg>
									</div>
								</div>
							</div>

						</div>
					{/if}
				</div>

				<!-- Performance Settings Category -->
				<div class="space-y-[0.6vh]">
					<button 
						on:click={() => toggleCategory('performance')}
						class="flex items-center justify-between w-full text-left group hover:bg-slate-800/30 rounded-[0.2vh] px-[0.6vh] py-[0.4vh] transition-colors duration-200"
					>
						<h3 class="text-slate-200 text-[1.2vh] font-medium">Performance Settings</h3>
						<svg 
							class="w-[1vh] h-[1vh] text-slate-400 transition-transform duration-200 {performanceSettingsOpen ? 'rotate-180' : ''}"
							fill="none" 
							stroke="currentColor" 
							viewBox="0 0 24 24"
						>
							<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"></path>
						</svg>
					</button>
					
					{#if performanceSettingsOpen}
						<div class="space-y-[0.6vh] pl-[0.6vh]" transition:slide={{ duration: 200 }}>
							
							<!-- Compass Interval -->
							<div class="flex items-center justify-between">
								<label class="text-slate-300 text-[1.1vh] font-medium">Compass Interval</label>
								<div class="relative">
									<select 
										bind:value={$Hud.HudSettings.CompassInterval}
										on:change={(e) => setCompassInterval(e.target.value)}
										class="appearance-none bg-slate-800/60 hover:bg-slate-700/70 focus:bg-slate-700/80 text-slate-200 px-[0.8vh] py-[0.4vh] pr-[2vh] rounded-[0.2vh] border border-slate-600/30 hover:border-slate-500/50 focus:border-emerald-500/50 text-[0.9vh] font-medium min-w-[7vh] transition-all duration-200 cursor-pointer focus:outline-none focus:ring-1 focus:ring-emerald-500/30"
									>
										<option value="High" class="bg-slate-800 text-slate-200">High</option>
										<option value="Low" class="bg-slate-800 text-slate-200">Low</option>
									</select>
									<!-- Custom dropdown arrow -->
									<div class="absolute inset-y-0 right-0 flex items-center pr-[0.6vh] pointer-events-none">
										<svg class="w-[0.8vh] h-[0.8vh] text-slate-400 transition-colors duration-200" fill="none" stroke="currentColor" viewBox="0 0 24 24">
											<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"></path>
										</svg>
									</div>
								</div>
							</div>
						</div>
					{/if}
				</div>
			</div>

			<!-- Footer -->
			<div class="flex items-center justify-between px-[1.5vh] py-[1vh] border-t border-slate-700/40">
				<div class="relative">
					<button
						on:click={saveSettings}
						class="px-[1.2vh] py-[0.6vh] bg-slate-900/90 hover:bg-slate-800/90 active:bg-slate-700/90 text-slate-200 hover:text-emerald-400 active:text-emerald-300 text-[1vh] font-medium rounded-[0.2vh] border border-slate-600/30 hover:border-emerald-400/50 active:border-emerald-500/70 transition-all duration-150 shadow-md hover:shadow-emerald-400/10 active:shadow-none cursor-pointer flex items-center justify-center relative focus:outline-none focus:ring-2 focus:ring-emerald-400/40"
					>
						Save
					</button>
				</div>
			</div>
		</div>
	</div>
{/if}

<style>
	.slider::-webkit-slider-thumb {
		appearance: none;
		width: 1.3vh;
		height: 1.3vh;
		border-radius: 50%;
		background: #10b981;
		cursor: pointer;
		border: 2px solid #065f46;
		box-shadow: 0 0 4px rgba(16, 185, 129, 0.4);
	}

	.slider::-moz-range-thumb {
		width: 1.3vh;
		height: 1.3vh;
		border-radius: 50%;
		background: #10b981;
		cursor: pointer;
		border: 2px solid #065f46;
		box-shadow: 0 0 4px rgba(16, 185, 129, 0.4);
	}
</style>