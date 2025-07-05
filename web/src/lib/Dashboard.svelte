<script lang="ts">
	import Minimap from "$lib/components/Minimap.svelte";
	import Compass from "$lib/components/Compass.svelte";
	import Stats_A from "$lib/components/Stats_A.svelte";
	import Stats_B from "$lib/components/Stats_B.svelte";
	import { Hud } from "./stores/VisibilityStore";
	import { fade } from 'svelte/transition';

</script>

<svelte:head>
	<link href="https://fonts.googleapis.com/css2?family=Share+Tech&display=swap" rel="stylesheet">
</svelte:head>

<div class="relative h-screen w-full p-4 text-white font-sans" style="font-family: 'Share Tech', sans-serif;" transition:fade={{ duration: 300 }}>
	<Minimap />
	{#if $Hud.ShowCompass }
		<Compass />
	{/if}
	<Stats_A />
	<!-- <Stats_B /> -->
</div>