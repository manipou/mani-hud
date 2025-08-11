<script lang="ts">
	import { Hud } from "$lib/stores/VisibilityStore";
</script>

<svelte:head>
	<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
</svelte:head>

 <!-- Weapon Showcase positioned above the main box -->
{#if $Hud.HasWeapon}
    <div class="absolute bottom-[calc(21.3vh+1.5vh)] left-[1.5vw] flex flex-col gap-1 font-['Inter'] select-none">
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