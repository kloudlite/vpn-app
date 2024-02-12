import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color? color;
  final Color? textColor;

  const RoundedButton(
      {super.key,
      required this.label,
      required this.onPressed,
      this.color,
      this.textColor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 100,
        height: 40,
        child: TextButton(
          onPressed: onPressed,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(color ?? Colors.blue),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: textColor ?? Colors.white,
              fontWeight: FontWeight.w400,
            ),
          ),
        ));
  }
}

class InputBox extends StatelessWidget {
  const InputBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Expose Ports',
              suffix: TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Expose',
                    style: TextStyle(color: Colors.blue),
                  )),
              hintStyle: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class KChip extends StatelessWidget {
  final String label;

  const KChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 2,
        runSpacing: 20,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
          Icon(
            Icons.close,
            size: 16,
            color: Colors.grey[400],
          )
        ],
      ),
    );
  }
}

class InfoBlock extends StatelessWidget {
  final String label;
  final String value;
  final Widget? valueWidget;

  const InfoBlock(
      {super.key, required this.label, this.value = "", this.valueWidget});

  @override
  Widget build(BuildContext context) {
    var v = valueWidget ??
        Text(
          value,
          style: const TextStyle(
            fontSize: 17,
            color: Colors.black,
            overflow: TextOverflow.ellipsis,
          ),
        );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding:
              const EdgeInsets.only(left: 10, top: 20, bottom: 20, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 5),
              v,
            ],
          ),
        ),
        Divider(
          thickness: 1,
          color: Colors.grey[100],
          height: 0,
        )
      ],
    );
  }
}

class BodyContainer extends StatelessWidget {
  final List<Widget> children;

  const BodyContainer({super.key, this.children = const <Widget>[]});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: children,
      ),
    );
  }
}
