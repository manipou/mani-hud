<script lang="ts">
	import { Hud } from "$lib/stores/VisibilityStore";
    import { tweened } from "svelte/motion";
	import { cubicOut } from "svelte/easing";
	import { fade } from 'svelte/transition';


	const speed = tweened(0, {
		duration: 300,
		easing: cubicOut
	});

	$: {
		if ($Hud.Speed !== undefined) {
			speed.set($Hud.Speed);
		}
	}
</script>

<svelte:head>
	<link href="https://fonts.googleapis.com/css2?family=Share+Tech&display=swap" rel="stylesheet">
</svelte:head>

<!-- Vehicle HUD Info -->
<div class="absolute bottom-[3vh] left-0 w-[100%] h-[18.4vh] flex flex-col justify-end" transition:fade={{ duration: 300 }}>
    <div class="relative w-full pb-[0vh]">
        <div class="flex justify-between items-center px-[0.5vw]">
            <div class="flex items-center gap-1">
                <div class="text-cyan-300 text-[2vh] font-bold tracking-wider drop-shadow-[0_0_5px_rgba(0,195,255,0.8)]">
                    {Math.round($Hud.Fuel)}
                </div>
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512" fill="currentColor" class="w-[1.2vh] h-[1.2vh] text-cyan-300/80">
                    <path d="M32 64C32 28.7 60.7 0 96 0H256c35.3 0 64 28.7 64 64V256h8c48.6 0 88 39.4 88 88v32c0 13.3 10.7 24 24 24s24-10.7 24-24V222c-27.6-7.1-48-32.2-48-62V96L384 64c-8.8-8.8-8.8-23.2 0-32s23.2-8.8 32 0l77.3 77.3c12 12 18.7 28.3 18.7 45.3V168v24 32V376c0 39.8-32.2 72-72 72s-72-32.2-72-72V344c0-22.1-17.9-40-40-40h-8V448c17.7 0 32 14.3 32 32v32H32c-17.7 0-32-14.3-32-32s14.3-32 32-32V64zM96 80v96c0 8.8 7.2 16 16 16H240c8.8 0 16-7.2 16-16V80c0-8.8-7.2-16-16-16H112c-8.8 0-16 7.2-16 16z"/>
                </svg>
            </div>

            <div class="text-right">
                <div class="text-cyan-300 text-[2vh] font-bold tracking-wider drop-shadow-[0_0_5px_rgba(0,195,255,0.8)]">
                    {Math.round($speed)}<span class="text-[1.75vh] ml-1">{$Hud.SpeedUnit}</span>
                </div>
            </div>
        </div>
    </div>
</div>