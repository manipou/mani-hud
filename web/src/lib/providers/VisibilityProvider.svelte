<script lang="ts">
	import { visibilityStore as visibility, Hud } from "$lib/stores/VisibilityStore";
	import { useNuiEvent } from "$lib/hooks/useNuiEvent";

	useNuiEvent<boolean>("setVisible", (visible) => {
		visibility.toggle(visible);
	});

	useNuiEvent<{
		Force?: boolean;
		ShowCompass?: boolean;
		Health?: number;
		Armor?: number;
		Hunger?: number;
		Thirst?: number;
		HasWeapon?: boolean;
		Weapon?: string;
		Ammo?: number;
		MaxAmmo?: number;
		InVehicle?: boolean;
		Speed?: number;
		Fuel?: number;
		SpeedUnit?: string;
		Heading?: number;
		ServerLogo?: string;
		PlayerCount?: number;
		Talking?: boolean;
		VoiceRange?: number;
		AspectRatio?: number;
		Currency?: {
			Symbol: string;
			Position: string;
			Separator: string;
		}
		PlayerData?: {
			Job?: string;
			Grade?: string;
			Money?: number;
			BlackMoney?: number;
			Bank?: number;
		}
		HudSettings?: {
			ShowMenu: boolean;
			ShowCompass: string;
			Stats: string;
			ServerInfo: string;
			CompassInterval: string;
			CompassMode: string;
			Offsets: {
				ServerInfo: { X: number; Y: number }
			}
		}
	}>('updateHud', (data) => {
		if (data.Force) {
			visibility.show();
		}

		Hud.update((current) => ({
			...current,
			...data,
			PlayerData: {
				...current.PlayerData,
				...data.PlayerData,
			},
			HudSettings: {
				...current.HudSettings,
				...data.HudSettings,
			}
		}));
	});
</script>

{#if $visibility}
	<slot />
{/if}