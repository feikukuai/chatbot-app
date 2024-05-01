import 'package:ChatBot/base.dart';
import 'package:ChatBot/base/providers.dart';
import 'package:ChatBot/base/theme.dart';
import 'package:ChatBot/utils/hive_box.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingPage extends ConsumerStatefulWidget {
  const SettingPage({super.key});

  @override
  ConsumerState createState() => _SettingPageState();
}

class _SettingPageState extends ConsumerState<SettingPage> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 1), () async {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String version = packageInfo.version;
      String buildNumber = packageInfo.buildNumber;
      ref.watch(versionProvider.notifier).state = "$version($buildNumber)";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.home_setting),
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.paddingOf(context).bottom +
                kBottomNavigationBarHeight,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                ),
                child: Text(
                  S.current.other_set,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 8,
                  bottom: 8,
                ),
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Card(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 3, horizontal: 16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                S.current.auto_title,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Consumer(builder: (context, ref, _) {
                                return CupertinoSwitch(
                                    value: ref.watch(autoGenerateTitleProvider),
                                    onChanged: (v) {
                                      ref
                                          .read(autoGenerateTitleProvider
                                              .notifier)
                                          .change(v);
                                    });
                              }),
                            ),
                          ],
                        ),
                        const Divider(
                          indent: 0,
                          endIndent: 0,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                S.current.tempture,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            Consumer(builder: (context, ref, _) {
                              var defaultTemperature =
                                  ref.watch(defaultTemperatureProvider);

                              return PullDownButton(
                                scrollController: ScrollController(),
                                itemBuilder: (BuildContext context) {
                                  return List.generate(21,
                                          (index) => ((index) / 10).toString())
                                      .map((item) => PullDownMenuItem(
                                            title: item,
                                            onTap: () {
                                              ref
                                                  .watch(
                                                      defaultTemperatureProvider
                                                          .notifier)
                                                  .change(item);
                                            },
                                            iconColor:
                                                Theme.of(context).primaryColor,
                                            icon: item != defaultTemperature
                                                ? null
                                                : CupertinoIcons.checkmark_alt,
                                          ))
                                      .toList();
                                },
                                buttonBuilder: (BuildContext context,
                                    Future<void> Function() showMenu) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    child: Row(children: [
                                      Text(
                                        defaultTemperature,
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .textTheme
                                              .titleSmall
                                              ?.color,
                                          fontSize: 15,
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Icon(
                                        CupertinoIcons.chevron_up_chevron_down,
                                        color: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.color,
                                        size: 16,
                                      ),
                                    ]).click(showMenu),
                                  );
                                },
                              );
                            }),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                ),
                child: Text(
                  S.current.theme_setting,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 8,
                  bottom: 8,
                ),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            S.current.theme,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        Consumer(builder: (context, ref, _) {
                          var theme = ref.watch(themeProvider);

                          return PullDownButton(
                            scrollController: ScrollController(),
                            itemBuilder: (BuildContext context) {
                              return [0, 1, 2]
                                  .map((item) => PullDownMenuItem(
                                        title: getNameByThemeType(item),
                                        onTap: () {
                                          ref
                                              .watch(themeProvider.notifier)
                                              .change(item);
                                        },
                                        iconColor:
                                            Theme.of(context).primaryColor,
                                        icon: item !=
                                                ref
                                                    .watch(
                                                        themeProvider.notifier)
                                                    .type
                                                    .index
                                            ? null
                                            : CupertinoIcons.checkmark_alt,
                                      ))
                                  .toList();
                            },
                            buttonBuilder: (BuildContext context,
                                Future<void> Function() showMenu) {
                              return Row(children: [
                                Text(
                                  getNameByThemeType(ref
                                      .watch(themeProvider.notifier)
                                      .type
                                      .index),
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.color,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Icon(
                                  CupertinoIcons.chevron_up_chevron_down,
                                  color: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.color,
                                  size: 16,
                                ),
                              ]).click(showMenu);
                            },
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 15,
                ),
                child: Text(
                  S.current.feedback,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 8,
                  bottom: 8,
                ),
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Card(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                S.current.feedback_question,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            Icon(
                              CupertinoIcons.right_chevron,
                              color:
                                  Theme.of(context).textTheme.titleSmall?.color,
                              size: 14,
                            ),
                          ],
                        ),
                      ).click(() {
                        launchUrl(Uri.parse(
                            "https://github.com/ChatBot-All/chatbot-app"));
                      }),
                      const Divider(
                        indent: 15,
                        endIndent: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Telegram",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            Icon(
                              CupertinoIcons.right_chevron,
                              color:
                                  Theme.of(context).textTheme.titleSmall?.color,
                              size: 14,
                            ),
                          ],
                        ),
                      ).click(() {
                        launchUrl(Uri.parse("https://t.me/chatbot_all"));
                      }),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 15,
                ),
                child: Center(
                  child: Consumer(builder: (context, ref, _) {
                    return Text(
                      "${S.current.version}: ${ref.watch(versionProvider)}",
                      style: Theme.of(context).textTheme.bodySmall,
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getNameByThemeType(int item) {
    switch (item) {
      case 0:
        return S.current.theme_normal;
      case 1:
        return S.current.theme_dark;
      case 2:
        return S.current.theme_auto;
      default:
        return '';
    }
  }
}

class SettingWithTitle extends StatelessWidget {
  final String label;
  final Widget widget;

  const SettingWithTitle(
      {super.key, required this.label, required this.widget});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 10),
          widget,
        ],
      ),
    );
  }
}

class SettingItem extends StatelessWidget {
  final String iconUrl;
  final String title;
  final String subTitle;
  final int count;

  const SettingItem(
      {super.key,
      required this.iconUrl,
      required this.title,
      required this.subTitle,
      this.count = 0});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).cardColor,
      child: Padding(
        padding:
            const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 50,
              height: 50,
              child: Image.asset(
                iconUrl,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                      if (count > 0)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: Text(
                            " ($count)",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Icon(
              CupertinoIcons.right_chevron,
              color: Theme.of(context).textTheme.titleSmall?.color,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
