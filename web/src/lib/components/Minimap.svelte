<script lang="ts">
	import { Hud } from "$lib/stores/VisibilityStore";
    import VehicleHud from "./VehicleHud.svelte"
    import Stats_C from "./Stats_C.svelte"

	let maxHealth = 100;
	let maxArmor = 100;

	function getPercentage(current: number, max: number): number {
		return (current / max) * 100;
	}
</script>

<svelte:head>
	<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
</svelte:head>

<div class="flex flex-col gap-2 absolute bottom-[1.5vh] left-[1.5vw] font-['Inter'] select-none" style="width: calc(16.2vw * (16/9) / {$Hud.AspectRatio}); height: 21.3vh;">
    {#if $Hud.HasWeapon}
    <div class="flex flex-col gap-1">
        <div class="text-slate-200 text-sm font-medium tracking-wide">
            {$Hud.Weapon}
        </div>

        <div class="flex items-center gap-2">
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" class="w-5 h-5 text-slate-300">
                <path d="M4 5c0-1.1.9-2 2-2h12a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2V5zm0 8c0-1.1.9-2 2-2h12a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2v-2zm0 8c0-1.1.9-2 2-2h12a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2v-2z"/>
            </svg>
            <div class="text-slate-100 text-3xl font-medium font-['JetBrains_Mono'] tracking-wide">
                {$Hud.Ammo.toString().padStart(3, '0')}<span class="text-slate-400 mx-1">|</span>{$Hud.MaxAmmo.toString().padStart(3, '0')}
            </div>
        </div>
    </div>
    {/if}

    <div class="flex-grow"></div>

    <div class="flex gap-[0.2vw] mt-auto">
        <!-- Health Bar -->
        <div class="flex items-center gap-2 flex-1">
            <div class="flex-1 h-[3vh] relative border border-cyan-400/25 shadow-[inset_0_0_8px_rgba(100,200,255,0.8)]">
                <!-- Unfilled portion background -->
                <div 
                    class="absolute right-0 h-full bg-[#600c16]/65 transition-all duration-300"
                    style="width: {100 - getPercentage($Hud.Health, maxHealth)}%"
                ></div>
                <div 
                    class="h-full bg-[#ff1a37]/65 transition-all duration-300"
                    style="width: {getPercentage($Hud.Health, maxHealth)}%"
                ></div>
                <div class="absolute inset-0 flex items-center justify-end pr-[1vh] font-bold text-[1.2vh] tracking-wider drop-shadow-[0_0_2px_rgba(0,0,0,0.4)]">
                    {$Hud.Health}
                </div>
                <div class="absolute inset-0 flex items-center justify-left pl-2">
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="white" class="w-[1.5vh] h-[1.5vh]">
                        <path d="M11.645 20.91l-.007-.003-.022-.012a15.247 15.247 0 01-.383-.218 25.18 25.18 0 01-4.244-3.17C4.688 15.36 2.25 12.174 2.25 8.25 2.25 5.322 4.714 3 7.688 3A5.5 5.5 0 0112 5.052 5.5 5.5 0 0116.313 3c2.973 0 5.437 2.322 5.437 5.25 0 3.925-2.438 7.111-4.739 9.256a25.175 25.175 0 01-4.244 3.17 15.247 15.247 0 01-.383.219l-.022.012-.007.004-.003.001a.752.752 0 01-.704 0l-.003-.001z" />
                    </svg> 
                </div>
            </div>
        </div>

        <!-- Armor Bar -->
        {#if $Hud.Armor > 0}
        <div class="flex items-center gap-2 flex-1">
            <div class="flex-1 h-[3vh] relative border border-cyan-400/25 shadow-[inset_0_0_8px_rgba(100,200,255,0.8)]">
                <!-- Unfilled portion background -->
                <div 
                    class="absolute right-0 h-full bg-[#005681]/65 transition-all duration-300"
                    style="width: {100 - getPercentage($Hud.Armor, maxArmor)}%"
                ></div>
                <div 
                    class="h-full bg-[#42c0ff]/65 transition-all duration-300"
                    style="width: {getPercentage($Hud.Armor, maxArmor)}%"
                ></div>
                <div class="absolute inset-0 flex items-center justify-end pr-[1vh] font-bold text-[1.2vh] tracking-wider drop-shadow-[0_0_2px_rgba(0,0,0,0.4)]">
                    {$Hud.Armor}
                </div>
                <div class="absolute inset-0 flex items-center justify-left pl-2">
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="white" class="w-[1.5vh] h-[1.5vh]">
                        <path d="M11.1385 2.29633C11.6899 2.06789 12.3094 2.06789 12.8608 2.29633L19.409 5.00923C20.1849 5.33068 20.7473 6.07313 20.7701 6.95597C20.8871 11.5013 19.4296 17.7631 13.067 21.5139C12.4101 21.9012 11.5955 21.9047 10.9353 21.5237C4.43153 17.7707 3.09402 11.4935 3.22752 6.95318C3.2534 6.07287 3.81392 5.33089 4.59034 5.00922L11.1385 2.29633ZM15.507 8.71521C15.2141 8.42231 14.7393 8.42231 14.4464 8.71521L10.9648 12.1967L9.55353 10.7854C9.26063 10.4925 8.78576 10.4926 8.49287 10.7854C8.19998 11.0783 8.19998 11.5532 8.49287 11.8461L10.4345 13.7877C10.7274 14.0806 11.2023 14.0806 11.4952 13.7877L15.507 9.77587C15.7999 9.48297 15.7999 9.0081 15.507 8.71521Z"/>
                    </svg>
                </div>
            </div>
        </div>
        {/if}

        <!-- Hunger Bar -->
        <div class="w-[3vh] h-[3vh] relative border border-cyan-400/25 shadow-[inset_0_0_8px_rgba(100,200,255,0.8)]">
            <div 
                class="absolute top-0 w-full bg-[#8B4513]/65 transition-all duration-300"
                style="height: {100 - $Hud.Hunger}%"
            ></div>
            <div 
                class="absolute bottom-0 w-full bg-[#FFA500]/65 transition-all duration-300"
                style="height: {$Hud.Hunger}%"
            ></div>
            <div class="absolute inset-0 flex items-center justify-center">
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" class="w-[1.2vh] h-[1.2vh]">
                    <path d="M3.25 9C3.25 6.10051 5.60051 3.75 8.5 3.75H15.5C18.3995 3.75 20.75 6.10051 20.75 9V9.40675C20.435 9.30498 20.0989 9.25 19.75 9.25H4.25C3.90109 9.25 3.56503 9.30498 3.25 9.40675V9Z" fill="#ffffff"/>
                    <path d="M3.25 10.4839C2.50914 10.8521 2 11.6166 2 12.5C2 13.3834 2.50914 14.1479 3.25 14.5161C3.55124 14.6658 3.89079 14.75 4.25 14.75H19.75C20.1092 14.75 20.4488 14.6658 20.75 14.5161C21.4909 14.1479 22 13.3834 22 12.5C22 11.6166 21.4909 10.8521 20.75 10.4839C20.4488 10.3342 20.1092 10.25 19.75 10.25H4.25C3.89079 10.25 3.55124 10.3342 3.25 10.4839Z" fill="#ffffff"/>
                    <path d="M20.75 15.5933C20.435 15.695 20.0989 15.75 19.75 15.75H4.25C3.9011 15.75 3.56503 15.695 3.25 15.5933V18C3.25 19.2426 4.25736 20.25 5.5 20.25H18.5C19.7426 20.25 20.75 19.2426 20.75 18V15.5933Z" fill="#ffffff"/>
                </svg>                    
            </div>
        </div>

        <!-- Thirst Bar -->
        <div class="w-[3vh] h-[3vh] relative border border-cyan-400/25 shadow-[inset_0_0_8px_rgba(100,200,255,0.8)]">
            <div 
                class="absolute top-0 w-full bg-[#005681]/65 transition-all duration-300"
                style="height: {100 - $Hud.Thirst}%"
            ></div>
            <div
                class="absolute bottom-0 w-full bg-[#42c0ff]/65 transition-all duration-300"
                style="height: {$Hud.Thirst}%"
            ></div>
            <div class="absolute inset-0 flex items-center justify-center">
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 320 512" fill="white" class="w-[1.2vh] h-[1.2vh]">
                    <path d="M120 0l80 0c13.3 0 24 10.7 24 24l0 40L96 64l0-40c0-13.3 10.7-24 24-24zM32 167.5c0-19.5 10-37.6 26.6-47.9l15.8-9.9C88.7 100.7 105.2 96 122.1 96l75.8 0c16.9 0 33.4 4.7 47.7 13.7l15.8 9.9C278 129.9 288 148 288 167.5c0 17-7.5 32.3-19.4 42.6C280.6 221.7 288 238 288 256c0 19.1-8.4 36.3-21.7 48c13.3 11.7 21.7 28.9 21.7 48s-8.4 36.3-21.7 48c13.3 11.7 21.7 28.9 21.7 48c0 35.3-28.7 64-64 64L96 512c-35.3 0-64-28.7-64-64c0-19.1 8.4-36.3 21.7-48C40.4 388.3 32 371.1 32 352s8.4-36.3 21.7-48C40.4 292.3 32 275.1 32 256c0-18 7.4-34.3 19.4-45.9C39.5 199.7 32 184.5 32 167.5zM96 240c0 8.8 7.2 16 16 16l96 0c8.8 0 16-7.2 16-16s-7.2-16-16-16l-96 0c-8.8 0-16 7.2-16 16zm16 112c-8.8 0-16 7.2-16 16s7.2 16 16 16l96 0c8.8 0 16-7.2 16-16s-7.2-16-16-16l-96 0z"/>
                </svg>
            </div>
        </div>
    </div>

    {#if $Hud.InVehicle}
        <VehicleHud />
    {/if}


    {#if $Hud.HudSettings.Stats === 'C'}
        <Stats_C />
    {/if}
</div>